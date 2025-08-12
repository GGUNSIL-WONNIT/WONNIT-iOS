//
//  ScanStorageManager.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import Foundation
import RoomPlan
import UIKit
import SceneKit
import Metal

@MainActor
final class ScanStorageManager {
    static let shared = ScanStorageManager()
    
    private init() { }
    
    private let screenshotManager = ScreenshotManager()
    
    struct ThumbnailOptions {
        enum Style { case perspective, topDownOrtho }
        var size: CGSize = .init(width: 512, height: 512)
        var style: Style = .perspective
        var margin: CGFloat = 0.15
        var background: UIColor = .white
        var environmentIntensity: CGFloat = 0.0
    }
    
    func save(capturedRoom: CapturedRoom, screenshot: UIImage?) async -> RoomData? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory.")
            return nil
        }
        let roomURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).usdz")
        
        do {
            try capturedRoom.export(to: roomURL, exportOptions: .parametric)
        } catch {
            print("Failed to export room: \(error)")
            return nil
        }
//        
//        guard let thumbnail = await renderThumbnail(from: roomURL) else {
//            print("Failed to generate thumbnail.")
//            try? FileManager.default.removeItem(at: roomURL)
//            return nil
//        }
        
        guard let screenshot else {
            print("Failed to generate thumbnail.")
            try? FileManager.default.removeItem(at: roomURL)
            return nil
        }
        
        guard let thumbnail = await extractThumbnailFromScreenshot(screenshot) else {
            print("Failed to generate thumbnail.")
            try? FileManager.default.removeItem(at: roomURL)
            return nil
        }
        
        return RoomData(roomURL: roomURL, thumbnail: thumbnail)
    }
    
    private func extractThumbnailFromScreenshot(_ screenshot: UIImage) async -> UIImage? {
        return await screenshotManager.removeBackground(image: screenshot)
    }
    
//    func renderThumbnail(from url: URL, options: ThumbnailOptions = .init()) async -> UIImage? {
//        do {
//            let scene = try SCNScene(url: url, options: [.checkConsistency: true])
//            sanitize(scene: scene)
//            applyLighting(to: scene, options: options)
//            
//            let device = MTLCreateSystemDefaultDevice()
//            let renderer = SCNRenderer(device: device, options: nil)
//            renderer.scene = scene
//            renderer.autoenablesDefaultLighting = false
//            renderer.isJitteringEnabled = false
//            
//            let pov = makeCamera(for: scene, options: options)
//            renderer.pointOfView = pov
//            
//            scene.background.contents = options.background
//            
//            _ = CGRect(origin: .zero, size: options.size)
//            let image = renderer.snapshot(atTime: 0, with: options.size, antialiasingMode: .multisampling4X)
//            
//            return image
//        } catch {
//            print("Scene load error:", error)
//            return nil
//        }
//    }
//
//    private func sanitize(scene: SCNScene) {
//        scene.rootNode.enumerateChildNodes { node, _ in
//            node.castsShadow = true
//        }
//        scene.rootNode.childNodes
//            .filter { $0.camera != nil || $0.light != nil }
//            .forEach { $0.removeFromParentNode() }
//    }
//    
//    private func applyLighting(to scene: SCNScene, options: ThumbnailOptions) {
//        // Ambient
//        let ambient = SCNNode()
//        ambient.light = SCNLight()
//        ambient.light?.type = .ambient
//        ambient.light?.intensity = 250
//        ambient.light?.color = UIColor(white: 1.0, alpha: 1.0)
//        scene.rootNode.addChildNode(ambient)
//        
//        // Key light
//        let key = SCNNode()
//        key.light = SCNLight()
//        key.light?.type = .directional
//        key.light?.intensity = 900
//        key.light?.castsShadow = true
//        key.light?.shadowMode = .deferred
//        key.light?.shadowRadius = 4
//        key.light?.shadowColor = UIColor(white: 0, alpha: 0.2)
//        key.eulerAngles = SCNVector3(-.pi * 0.2, .pi * 0.25, 0)
//        scene.rootNode.addChildNode(key)
//        
//        // Fill light
//        let fill = SCNNode()
//        fill.light = SCNLight()
//        fill.light?.type = .directional
//        fill.light?.intensity = 450
//        fill.light?.castsShadow = false
//        fill.eulerAngles = SCNVector3(-.pi * 0.15, -.pi * 0.6, 0)
//        scene.rootNode.addChildNode(fill)
//        
//        if options.environmentIntensity > 0 {
//            let env = UIImage.solidColor(.white, size: .init(width: 2, height: 2))
//            scene.lightingEnvironment.contents = env
//            scene.lightingEnvironment.intensity = options.environmentIntensity
//        }
//    }
//    
//    
//    private func makeCamera(for scene: SCNScene, options: ThumbnailOptions) -> SCNNode {
//        let (center, size) = boundingBoxFlattened(for: scene.rootNode)
//        
//        let camera = SCNCamera()
//        camera.zNear = 0.001
//        camera.fieldOfView = 45
//        
//        let camNode = SCNNode()
//        camNode.camera = camera
//        
//        switch options.style {
//        case .perspective:
//            let aspect = max(0.0001, options.size.width / options.size.height)
//            let vFOV = CGFloat(camera.fieldOfView) * .pi / 180
//            let hFOV = 2 * atan(tan(vFOV * 0.5) * aspect)
//            let pad = (1 + options.margin)
//            let halfW = CGFloat(size.x) * 0.5 * pad
//            let halfH = CGFloat(size.y) * 0.5 * pad
//            let distForH = halfH / tan(vFOV * 0.5)
//            let distForW = halfW / tan(hFOV * 0.5)
//            let distance = max(distForH, distForW)
//            let dir = normalize(SCNVector3(x: 1, y: 0.8, z: 1))
//            let d = Float(distance)
//            camNode.position = SCNVector3(
//                x: center.x + dir.x * d,
//                y: center.y + dir.y * d,
//                z: center.z + dir.z * d
//            )
//            camNode.look(at: center, up: SCNVector3(x: 0, y: 1, z: 0), localFront: SCNVector3(x: 0, y: 0, z: -1))
//            
//            camera.zFar = Double(max(distance * 4, CGFloat(size.z) * 6))
//
//        case .topDownOrtho:
//            camera.usesOrthographicProjection = true
//            let aspect = max(0.0001, options.size.width / options.size.height)
//            let pad = (1 + options.margin)
//            let verticalNeeded = CGFloat(size.y) * pad
//            let verticalFromWidth = (CGFloat(size.x) / aspect) * pad
//            camera.orthographicScale = Double(max(verticalNeeded, verticalFromWidth))
//            camNode.position = SCNVector3(x: center.x,
//                                          y: center.y + max(size.x, size.y) * 3,
//                                          z: center.z)
//            camNode.look(at: center, up: SCNVector3(x: 0, y: 0, z: -1), localFront: SCNVector3(x: 0, y: -1, z: 0))
//            camera.zFar = Double(max(size.x, size.y) * 20)
//        }
//        return camNode
//    }
//    
//    private func boundingSphere(for root: SCNNode) -> (center: SCNVector3, radius: CGFloat) {
//        let flattened = root.flattenedClone()
//        
//        let (minV, maxV) = flattened.boundingBox
//        
//        let degenerate = (minV.x == maxV.x) && (minV.y == maxV.y) && (minV.z == maxV.z)
//        if degenerate {
//            return (SCNVector3(x: 0, y: 0, z: 0), 0.001)
//        }
//        
//        let center = SCNVector3(
//            x: (minV.x + maxV.x) * 0.5,
//            y: (minV.y + maxV.y) * 0.5,
//            z: (minV.z + maxV.z) * 0.5
//        )
//        
//        let dx: Float = maxV.x - minV.x
//        let dy: Float = maxV.y - minV.y
//        let dz: Float = maxV.z - minV.z
//        let diameterF: Float = max(dx, max(dy, dz))
//        let radius = CGFloat(max(diameterF * 0.5, 0.001))
//        
//        return (center, radius)
//    }
//    
//    private func boundingBoxFlattened(for root: SCNNode) -> (center: SCNVector3, size: SCNVector3) {
//        let flat = root.flattenedClone()
//        let (minV, maxV) = flat.boundingBox
//        
//        if (minV.x == maxV.x) && (minV.y == maxV.y) && (minV.z == maxV.z) {
//            return (SCNVector3(x: 0, y: 0, z: 0), SCNVector3(x: 0.001, y: 0.001, z: 0.001))
//        }
//        
//        let center = SCNVector3(
//            x: (minV.x + maxV.x) * 0.5,
//            y: (minV.y + maxV.y) * 0.5,
//            z: (minV.z + maxV.z) * 0.5
//        )
//        let size = SCNVector3(
//            x: (maxV.x - minV.x),
//            y: (maxV.y - minV.y),
//            z: (maxV.z - minV.z)
//        )
//        return (center, size)
//    }
//
//    
//    private func normalize(_ v: SCNVector3) -> SCNVector3 {
//        let len = max(0.0001, sqrt(v.x*v.x + v.y*v.y + v.z*v.z))
//        return SCNVector3(v.x/len, v.y/len, v.z/len)
//    }
}

//private extension UIImage {
//    static func solidColor(_ color: UIColor, size: CGSize) -> UIImage {
//        let r = UIGraphicsImageRenderer(size: size)
//        return r.image { ctx in
//            color.setFill()
//            ctx.fill(CGRect(origin: .zero, size: size))
//        }
//    }
//}
