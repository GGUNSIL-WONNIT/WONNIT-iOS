//
//  UIImage+Extension.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation
import UIKit

enum ImageBrightness {
    case light, dark
}

extension UIImage {
    func brightness(threshold: CGFloat = 0.5) -> ImageBrightness {
        guard let cgImage = self.cgImage else { return .light }
        
        let size = CGSize(width: 8, height: 8)
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: Int(size.width) * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let data = context?.data else { return .light }
        
        let pixelCount = Int(size.width * size.height)
        var totalLuminance: CGFloat = 0
        
        for i in 0..<pixelCount {
            let offset = i * 4
            let r = CGFloat(data.load(fromByteOffset: offset, as: UInt8.self)) / 255
            let g = CGFloat(data.load(fromByteOffset: offset + 1, as: UInt8.self)) / 255
            let b = CGFloat(data.load(fromByteOffset: offset + 2, as: UInt8.self)) / 255
            totalLuminance += 0.299 * r + 0.587 * g + 0.114 * b
        }
        
        let avgLuminance = totalLuminance / CGFloat(pixelCount)
        return avgLuminance < threshold ? .dark : .light
    }
}
