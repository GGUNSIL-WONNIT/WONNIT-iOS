//
//  SpaceModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import Foundation

struct Space: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String?
    var address: AddressInfo?
    var mainImageURL: URL?
    var subImageURLs: [URL]?
    var category: SpaceCategory?
    var size: Double?
    var operationInfo: OperationalInfo?
    var amountInfo: AmountInfo?
    var spaceModelURL: URL?
    var phoneNumber: PhoneNumber?
    var precautions: String?
    
    static let empty: Space = .init(
        id: UUID(),
        name: nil,
        address: nil,
        mainImageURL: nil,
        subImageURLs: nil,
        category: nil,
        size: nil,
        operationInfo: nil,
        amountInfo: nil,
        spaceModelURL: nil,
        phoneNumber: nil,
        precautions: nil
    )
    
    static let placeholder: Space = .init(
        id: UUID(),
        name: "",
        address: .init(address1: "서울 노원구 공릉로 232", address2: "서울과학기술대학교 상상관", lat: 37.630969, lon: 127.080339),
        mainImageURL: nil,
        subImageURLs: nil,
        category: .makerSpace,
        size: 100.0,
        operationInfo: .init(dayOfWeeks: [.MONDAY, .TUESDAY, .WEDNESDAY, .THURSDAY, .FRIDAY], startAt: DateComponents(hour: 5, minute: 0), endAt: DateComponents(hour: 23, minute: 0)),
        amountInfo: .init(timeUnit: .perDay, amount: 1000),
        spaceModelURL: nil,
        phoneNumber: .init(value: "02-970-6114"),
        precautions: "주의사항"
        )

    // MARK: - Validation
    var isValid: Bool {
        (name?.isEmpty == false) &&
        (name?.count ?? 0) <= 100 &&
        (size ?? -1) > 0 &&
        (operationInfo?.dayOfWeeks.count ?? 0) >= 1 &&
        (operationInfo?.startAt ?? .init()) < (operationInfo?.endAt ?? .init()) &&
        (phoneNumber?.isValid ?? false) &&
        (precautions?.count ?? 0) <= 500
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

