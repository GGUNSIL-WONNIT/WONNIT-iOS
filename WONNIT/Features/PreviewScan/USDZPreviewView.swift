//
//  USDZPreviewView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import SwiftUI
import SceneKit

struct USDZPreviewView: View {
    let resourceName: String
    let resourceExtension: String
    
    private var scene: SCNScene? {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: resourceExtension) else {
            fatalError("Couldn't find \(resourceName).\(resourceExtension) in bundle")
        }
        
        guard let scene = try? SCNScene(url: url, options: nil) else {
            return nil
        }
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: -6, y: 7, z: 6)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
    
    var body: some View {
        if let scene = scene {
            SceneView(
                scene: scene,
                options: [.allowsCameraControl, .autoenablesDefaultLighting]
            )
        } else {
            ContentUnavailableView {
                Label("오류", systemImage: "arkit")
            } description: {
                Text("공간 3D 모델을 불러올 수 없습니다.")
                    .body_04(.grey900)
            }
        }
    }
}

#Preview {
    USDZPreviewView(resourceName: "Room", resourceExtension: "usdz")
}
