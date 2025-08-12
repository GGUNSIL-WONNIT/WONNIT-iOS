//
//  ScreenshotManager.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import UIKit
import Vision
import CoreImage.CIFilterBuiltins

final class ScreenshotManager {
    func captureScreen() -> UIImage? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("Failed to get UIWindowScene")
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: windowScene.screen.bounds.size)
        
        let image = renderer.image { _ in
            for window in windowScene.windows {
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }
        }
        
        return image
    }
    
    func removeBackground(image: UIImage) async -> UIImage? {
        guard let inputImage = CIImage(image: image) else {
            fatalError("Failed to create CIImage")
        }
        
        return await Task.detached(priority: .userInitiated) {
            guard let maskImage = self.subjectMaskImage(from: inputImage) else {
                print("Failed to create mask image")
                return nil
            }
            let outputImage = self.apply(mask: maskImage, to: inputImage)
            let image = self.render(ciImage: outputImage)
            return image
        }.value
    }
    
    private func subjectMaskImage(from inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage, options: [:])
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        do {
            try handler.perform([request])
            guard let result = request.results?.first else {
                return nil
            }
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func apply(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage!
    }
    
    private func render(ciImage: CIImage) -> UIImage {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Failed to render CGImage")
        }
        return UIImage(cgImage: cgImage)
    }
}
