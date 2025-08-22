//
//  USDZPreviewView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import SwiftUI
import SceneKit

struct USDZPreviewView: View {
    let url: URL
    @State private var scene: SCNScene?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("다운로드 중...")
            } else if let scene = scene {
                SceneView(
                    scene: scene,
                    options: [.allowsCameraControl, .autoenablesDefaultLighting]
                )
            } else {
                ContentUnavailableView {
                    Label("오류", systemImage: "arkit")
                } description: {
                    Text(errorMessage ?? "공간 3D 모델을 불러올 수 없습니다.")
                        .body_04(.grey900)
                }
            }
        }
        .onAppear(perform: loadModel)
    }
    
    private func loadModel() {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "모델 다운로드 실패.\n\(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "모델을 불러올 수 없습니다.\ndata is nil"
                    self.isLoading = false
                }
                return
            }
            
            let fileManager = FileManager.default
            let tempDirectory = fileManager.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                try data.write(to: fileURL)
                let loadedScene = try SCNScene(url: fileURL, options: nil)
                
                let cameraNode = SCNNode()
                cameraNode.camera = SCNCamera()
                cameraNode.position = SCNVector3(x: -6, y: 7, z: 6)
                cameraNode.look(at: SCNVector3(0, 0, 0))
                loadedScene.rootNode.addChildNode(cameraNode)
                
                DispatchQueue.main.async {
                    self.scene = loadedScene
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "모델을 불러올 수 없습니다: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
        task.resume()
    }
}

#Preview {
    USDZPreviewView(url: URL(string: "https://github.com/GGUNGSIL-WONNIT/testing-USDZ-file-downloads/raw/refs/heads/main/Room.usdz")!)
}
