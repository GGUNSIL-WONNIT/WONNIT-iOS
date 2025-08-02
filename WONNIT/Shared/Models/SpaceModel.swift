//
//  SpaceModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import Foundation

struct Space: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var address: AddressInfo
    var mainImageURL: URL
    var subImageURLs: [URL]
    var category: SpaceCategory
    var size: Double
    var operationInfo: OperationalInfo
    var amountInfo: AmountInfo
    var spaceModelURL: URL?
    var phoneNumber: PhoneNumber
    var precautions: String

    // MARK: - Validation
    var isValid: Bool {
        !name.isEmpty &&
        name.count <= 100 &&
        size > 0 &&
        operationInfo.dayOfWeeks.count >= 1 &&
        operationInfo.startAt < operationInfo.endAt &&
        phoneNumber.isValid &&
        (precautions.count <= 500)
    }

    // MARK: - Domain Actions
//    static func register(from request: CreateSpaceRequest) -> Space {
//        return Space(
//            id: UUID(),
//            name: request.name,
//            address: request.address,
//            mainImageURL: request.mainImageURL,
//            subImageURLs: request.subImageURLs,
//            category: request.category,
//            size: request.size,
//            operationInfo: request.operationInfo,
//            amountInfo: request.amountInfo,
//            spaceModelURL: request.spaceModelURL,
//            phoneNumber: request.phoneNumber,
//            precautions: request.precautions
//        )
//    }

//    mutating func update(from request: UpdateSpaceRequest) {
//        self.name = request.name
//        self.address = request.address
//        self.mainImageURL = request.mainImageURL
//        self.subImageURLs = request.subImageURLs
//        self.category = request.category
//        self.size = request.size
//        self.operationInfo = request.operationInfo
//        self.amountInfo = request.amountInfo
//        self.spaceModelURL = request.spaceModelURL
//        self.phoneNumber = request.phoneNumber
//        self.precautions = request.precautions
//    }

//    mutating func delete() {
//        //
//    }
}

