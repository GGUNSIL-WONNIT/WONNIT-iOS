//
//  SpaceChangesMaskPredictor.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/20/25.
//

import Foundation
import UIKit
import CoreML
import Vision

final class SpaceChangesMaskPredictor {
    static let shared = SpaceChangesMaskPredictor()
    
    private lazy var mlModel: MLModel? = {
        do {
            let configuration = MLModelConfiguration()
            configuration.computeUnits = .cpuOnly
            let model = try SpaceChangesMaskModel(configuration: configuration).model
            return model
        } catch {
            return nil
        }
    }()
    
    func detectChanges(beforeImage: UIImage, afterImage: UIImage, completion: @escaping (Double?, UIImage?) -> Void) {
        guard let model = mlModel else {
            completion(nil, nil)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let beforePixelBuffer = self.preprocessImage(beforeImage),
                  let afterPixelBuffer = self.preprocessImage(afterImage) else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            
            do {
                let inputFeatures: [String: Any] = ["before": beforePixelBuffer, "after": afterPixelBuffer]
                let provider = try MLDictionaryFeatureProvider(dictionary: inputFeatures)
                
                let prediction = try model.prediction(from: provider, options: MLPredictionOptions())
                
                guard let multiArray = prediction.featureValue(for: "var_713")?.multiArrayValue else {
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                    return
                }
                
                let smallMaskedImage = self.imageFromMultiArray(multiArray: multiArray)
                let resizedMaskedImage = self.resizeImage(image: smallMaskedImage, targetSize: beforeImage.size)
                let changePercentage = self.calculateChangePercentage(from: multiArray)
                let matchPercentage = 100.0 - changePercentage
                
                DispatchQueue.main.async {
                    completion(matchPercentage, resizedMaskedImage)
                }
            } catch {
                print("Error performing prediction: \(error)")
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
    }
    
    private func preprocessImage(_ image: UIImage) -> CVPixelBuffer? {
        let size = CGSize(width: 256, height: 256)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            print("Error: Could not resize image.")
            return nil
        }
        UIGraphicsEndImageContext()
        
        guard let cgImage = resizedImage.cgImage else {
            print("Error: Could not get CGImage from UIImage.")
            return nil
        }
        
        let width = Int(size.width)
        let height = Int(size.height)
        
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let unwrappedPixelBuffer = pixelBuffer else {
            print("Error: Failed to create CVPixelBuffer.")
            return nil
        }
        
        CVPixelBufferLockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(unwrappedPixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedPixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            print("Error: Failed to create CGContext.")
            CVPixelBufferUnlockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return unwrappedPixelBuffer
    }
    
    private func imageFromMultiArray(multiArray: MLMultiArray) -> UIImage? {
        let height = multiArray.shape[2].intValue
        let width = multiArray.shape[3].intValue
        
        var buffer = [UInt8](repeating: 0, count: width * height)
        
        let multiArrayPointer = UnsafeMutablePointer<Float16>(OpaquePointer(multiArray.dataPointer))
        
        for i in 0..<(width * height) {
            let value = multiArrayPointer[i]
            buffer[i] = UInt8(max(0, min(255, Float(value) * 255.0)))
        }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        guard let provider = CGDataProvider(data: Data(buffer) as CFData) else {
            return nil
        }
        
        guard let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func calculateChangePercentage(from multiArray: MLMultiArray) -> Double {
        let width = multiArray.shape[3].intValue
        let height = multiArray.shape[2].intValue
        guard width > 0, height > 0 else { return 0.0 }
        
        let totalPixels = width * height
        var changedPixels = 0
        
        let multiArrayPointer = UnsafeMutablePointer<Float16>(OpaquePointer(multiArray.dataPointer))
        
        for i in 0..<(width * height) {
            if multiArrayPointer[i] > 0.5 {
                changedPixels += 1
            }
        }
        
        return (Double(changedPixels) / Double(totalPixels)) * 100.0
    }
}
