//
//  SpaceCategoryClassifier.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import CoreML
import Vision
import UIKit

struct SpaceCategoryClassifierPrediction: Identifiable, Equatable {
    let id = UUID()
    let label: SpaceCategory?
    let confidence: Double
}

final class SpaceCategoryClassifier {
    static let shared = SpaceCategoryClassifier()
    private let vnModel: VNCoreMLModel
    
    private init() {
        let cfg = MLModelConfiguration()
        let core = try! SpaceCategoryModel(configuration: cfg)
        self.vnModel = try! VNCoreMLModel(for: core.model)
    }
    
    func classifyTopK(_ image: UIImage, k: Int = 1) async throws -> [SpaceCategoryClassifierPrediction] {
        guard let cg = image.cgImage else { return [] }
        
        let request = VNCoreMLRequest(model: vnModel)
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(
            cgImage: cg,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )
        
        try handler.perform([request])
        
        let results = (request.results as? [VNClassificationObservation]) ?? []
        return results.prefix(k).map { .init(label: SpaceCategory(rawValue: String($0.identifier)), confidence: Double($0.confidence)) }
    }
}
