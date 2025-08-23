//
//  ImageUploaderService.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import Foundation
import UIKit
import Alamofire

enum ImageUploadError: Error {
    case failedToGetData
    case presignedURLRequestFailed(Error)
    case uploadFailed(Error)
    case invalidResponse
}

actor ImageUploaderService {
    static let shared = ImageUploaderService()
    func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ImageUploadError.failedToGetData
        }
        
        let presignResponse: Components.Schemas.PresignUploadResponse
        do {
            let client = try await WONNITClientAPIService.shared.client()
            let imageName = UUID().uuidString + ".jpg"
            let response = try await client.uploadImage(query: .init(imageName: imageName))
            presignResponse = try response.ok.body.json
        } catch {
            throw ImageUploadError.presignedURLRequestFailed(error)
        }
        
        let presignedURL = presignResponse.uploadUrl
        let finalImageURL = presignResponse.url
        
        do {
            try await AF.upload(imageData, to: presignedURL, method: .put).validate().serializingData()
        } catch {
            throw ImageUploadError.uploadFailed(error)
        }
        
        return finalImageURL
    }
    
    func uploadImages(_ images: [UIImage]) async throws -> [String] {
        return try await withThrowingTaskGroup(of: String.self, body: { group in
            var urls: [String] = []
            
            for image in images {
                group.addTask {
                    return try await self.uploadImage(image)
                }
            }
            
            for try await url in group {
                urls.append(url)
            }
            
            return urls
        })
    }
}
