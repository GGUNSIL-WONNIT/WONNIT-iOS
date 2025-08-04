//
//  SpaceModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct Space: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String?
    let address: AddressInfo?
    let mainImageURL: String?
    let subImageURLs: [String]?
    let category: SpaceCategory?
    let size: Double?
    let operationInfo: OperationalInfo?
    let amountInfo: AmountInfo?
    let spaceModelURL: String?
    let phoneNumber: PhoneNumber?
    let precautions: String?
    
    var coordinate: CLLocationCoordinate2D {
        address?.coordinate ?? .defaultCoordinate
    }
    
    var resolvedMainImageURL: URL? {
        guard let mainImageURL else { return nil }
        return URL(string: mainImageURL)
    }
    
    var resolvedSubImageURLs: [URL] {
        (subImageURLs ?? []).compactMap {
            guard let url = URL(string: $0) else {
                print("Invalid URL string: \($0)")
                return nil
            }
            return url
        }
    }
    
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
        name: "상상관 2층",
        address: .init(address1: "서울 노원구 공릉로 232", address2: "서울과학기술대학교 상상관", lat: 37.630969, lon: 127.080339),
        mainImageURL: "https://images.unsplash.com/photo-1595847568639-99fbd1b8fd81?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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
