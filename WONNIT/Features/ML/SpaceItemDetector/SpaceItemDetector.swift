//
//  SpaceItemDetector.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import Foundation
import CoreML
import Vision
import UIKit

struct SpaceItemDetection: Identifiable, Equatable {
    let id = UUID()
    let rawLabel: String
    let item: SpaceItem?
    let confidence: Double
    let boundingBox: CGRect
}

final class SpaceItemDetector {
    static let shared = SpaceItemDetector()
    
    private let vnModel: VNCoreMLModel
    
    private init() {
        let cfg = MLModelConfiguration()
        let core = try! SpaceItemDetectionModel(configuration: cfg)
        self.vnModel = try! VNCoreMLModel(for: core.model)
        self.vnModel.featureProvider = nil
    }
    
    func detect(in image: UIImage, minConfidence: Float = 0.35, maxDetections: Int = 10) async throws -> [SpaceItemDetection] {
        guard let cg = image.cgImage else { return [] }
        
        let request = VNCoreMLRequest(model: vnModel)
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(
            cgImage: cg,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )
        
        try handler.perform([request])
        
        let objects = (request.results as? [VNRecognizedObjectObservation]) ?? []
        let mapped: [SpaceItemDetection] = objects.compactMap { obs in
            guard let best = obs.labels.first, best.confidence >= minConfidence else { return nil }
            let raw = best.identifier.replacingOccurrences(of: "_", with: " ")
            return SpaceItemDetection(
                rawLabel: raw,
                item: SpaceItem(rawValue: raw),
                confidence: Double(best.confidence),
                boundingBox: obs.boundingBox
            )
        }
        
        return Array(mapped.sorted(by: { $0.confidence > $1.confidence }).prefix(maxDetections))
    }
    
    func topLabels(in image: UIImage, minConfidence: Float = 0.35, maxItems: Int = 10) async throws -> [SpaceItem] {
        let dets = try await detect(in: image, minConfidence: minConfidence, maxDetections: 128)
        let known = dets.compactMap { $0.item }
        let bestPerItem = Dictionary(grouping: known, by: { $0 })
            .mapValues { items in
                dets.first(where: { $0.item == items.first })?.confidence ?? 0
            }
        return bestPerItem
            .sorted(by: { $0.value > $1.value })
            .prefix(maxItems)
            .map { $0.key }
    }
}
