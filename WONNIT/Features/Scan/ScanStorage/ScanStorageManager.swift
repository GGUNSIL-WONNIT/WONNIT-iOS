//
//  ScanStorageManager.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import Foundation
import RoomPlan
import SwiftUI
import SceneKit

@MainActor
final class ScanStorageManager {
    static let shared = ScanStorageManager()
    
    private init() { }
    
    func save(capturedRoom: CapturedRoom) async -> RoomData? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Failed to get documents directory.")
            print("\(#fileID) \(#line)-line, \(#function)")
            return nil
        }
        let roomURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).usdz")
        
        do {
            try capturedRoom.export(to: roomURL, exportOptions: .parametric)
        } catch {
            print("Failed to export room: \(error)")
            print("\(#fileID) \(#line)-line, \(#function)")
            return nil
        }
        
        guard let thumbnail = renderThumbnail(from: roomURL) else {
            print("Failed to generate thumbnail.")
            print("\(#fileID) \(#line)-line, \(#function)")
            try? FileManager.default.removeItem(at: roomURL)
            return nil
        }
        
        return RoomData(roomURL: roomURL, thumbnail: thumbnail)
    }
    
    private func renderThumbnail(from url: URL, size: CGSize = CGSize(width: 300, height: 300)) -> UIImage? {
        let scnView = SCNView(frame: CGRect(origin: .zero, size: size))
        
        do {
            let scene = try SCNScene(url: url, options: nil)
            scnView.scene = scene
            scnView.autoenablesDefaultLighting = true
            scnView.pointOfView = makeFitCamera(for: scene)
            scnView.antialiasingMode = .multisampling4X
            
            let image = scnView.snapshot()
            return image
        } catch {
            print("Failed to rendering thumbnail: \(error)")
            print("\(#fileID) \(#line)-line, \(#function)")
            return nil
        }
    }
    
    private func makeFitCamera(for scene: SCNScene) -> SCNNode {
        let (boundingMin, boundingMax) = scene.rootNode.boundingBox
        let center = SCNVector3(
            (boundingMin.x + boundingMax.x) / 2,
            (boundingMin.y + boundingMax.y) / 2,
            (boundingMin.z + boundingMax.z) / 2
        )
        let size = SCNVector3(
            boundingMax.x - boundingMin.x,
            boundingMax.y - boundingMin.y,
            boundingMax.z - boundingMin.z
        )
        let largestDimension = max(size.x, size.y, size.z)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(center.x, center.y, center.z + largestDimension * 2.5)
        return cameraNode
    }
}
