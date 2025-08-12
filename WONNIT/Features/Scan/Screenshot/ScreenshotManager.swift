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
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        let renderer = UIGraphicsImageRenderer(size: windowScene.screen.bounds.size)
        return renderer.image { _ in
            for window in windowScene.windows where !window.isHidden && window.alpha > 0 {
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }
        }
    }
    
    func removeBackground(image: UIImage, padding: CGFloat = 4, bottomSpacing: CGFloat = 16, maxDimension: CGFloat? = 512) async -> UIImage? {
        guard let inputCI = CIImage(image: image) else { return nil }
        return await Task.detached(priority: .userInitiated) {
            guard let maskCI = self.subjectMaskImage(from: inputCI) else { return nil }
            let composed = self.apply(mask: maskCI, to: inputCI)
            guard var bbox = self.boundingBox(fromMask: maskCI, imageExtent: composed.extent, targetMax: 512, threshold: 8) else {
                return self.render(ciImage: composed).resizedIfNeeded(maxDimension: maxDimension)
            }
            if padding > 0 || bottomSpacing > 0 {
                bbox = CGRect(
                    x: bbox.minX - padding,
                    y: bbox.minY - padding,
                    width: bbox.width + padding * 2,
                    height: bbox.height + padding * 2 + bottomSpacing
                ).intersection(composed.extent)
            }
            let cropped = composed.cropped(to: bbox)
            return self.render(ciImage: cropped).resizedIfNeeded(maxDimension: maxDimension)
        }.value
    }
    
    private func boundingBox(fromMask mask: CIImage, imageExtent: CGRect, targetMax: CGFloat, threshold: UInt8) -> CGRect? {
        let w0 = mask.extent.width
        let h0 = mask.extent.height
        guard w0 > 0, h0 > 0 else { return nil }
        let scale = min(1.0, targetMax / max(w0, h0))
        let scaled = mask.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let ctx = CIContext(options: [.workingColorSpace: NSNull(), .outputColorSpace: NSNull()])
        let w = Int(scaled.extent.width.rounded(.toNearestOrAwayFromZero))
        let h = Int(scaled.extent.height.rounded(.toNearestOrAwayFromZero))
        guard w > 0, h > 0 else { return nil }
        var buf = [UInt8](repeating: 0, count: w * h * 4)
        ctx.render(scaled,
                   toBitmap: &buf,
                   rowBytes: w * 4,
                   bounds: CGRect(x: 0, y: 0, width: w, height: h),
                   format: .RGBA8,
                   colorSpace: nil)
        
        var minX = w, maxX = -1, minY = h, maxY = -1
        for y in 0..<h {
            let rowBase = y * w * 4
            for x in 0..<w {
                if buf[rowBase + x * 4] > threshold {
                    if x < minX { minX = x }
                    if x > maxX { maxX = x }
                    if y < minY { minY = y }
                    if y > maxY { maxY = y }
                }
            }
        }
        guard maxX >= minX, maxY >= minY else { return nil }
        let inv = 1.0 / scale
        let x0 = CGFloat(minX) * inv
        let y0 = CGFloat(minY) * inv
        let x1 = CGFloat(maxX + 1) * inv
        let y1 = CGFloat(maxY + 1) * inv
        var rect = CGRect(x: imageExtent.minX + x0,
                          y: imageExtent.minY + y0,
                          width: max(1, x1 - x0),
                          height: max(1, y1 - y0))
        rect = rect.intersection(imageExtent)
        return rect.isEmpty ? nil : rect
    }
    
    private func subjectMaskImage(from inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage, options: [:])
        let request = VNGenerateForegroundInstanceMaskRequest()
        do {
            try handler.perform([request])
            guard let result = request.results?.first else { return nil }
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            return nil
        }
    }
    
    private func apply(mask: CIImage, to image: CIImage) -> CIImage {
        let f = CIFilter.blendWithMask()
        f.inputImage = image
        f.maskImage = mask
        f.backgroundImage = CIImage.empty()
        return (f.outputImage ?? image).cropped(to: image.extent)
    }
    
    private func render(ciImage: CIImage) -> UIImage {
        let ctx = CIContext(options: nil)
        guard let cg = ctx.createCGImage(ciImage, from: ciImage.extent) else { return UIImage() }
        return UIImage(cgImage: cg, scale: UIScreen.main.scale, orientation: .up)
    }
}

private extension UIImage {
    func resizedIfNeeded(maxDimension: CGFloat?) -> UIImage {
        guard let maxDim = maxDimension, maxDim > 0 else { return self }
        let longer = max(size.width, size.height)
        guard longer > maxDim else { return self }
        let scale = maxDim / longer
        let target = CGSize(width: size.width * scale, height: size.height * scale)
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false
        format.scale = 1
        return UIGraphicsImageRenderer(size: target, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: target))
        }
    }
}
