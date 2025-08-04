//
//  Space+Extensions.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import Foundation

extension Space {
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
        subImageURLs: [
            "https://images.unsplash.com/photo-1497215728101-856f4ea42174?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://images.unsplash.com/photo-1462826303086-329426d1aef5?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://images.unsplash.com/photo-1686100511314-7d4a52987f2f?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        ],
        category: .makerSpace,
        size: 100.0,
        operationInfo: .init(dayOfWeeks: [.MONDAY, .TUESDAY, .WEDNESDAY, .THURSDAY, .FRIDAY], startAt: DateComponents(hour: 5, minute: 0), endAt: DateComponents(hour: 23, minute: 0)),
        amountInfo: .init(timeUnit: .perDay, amount: 1000),
        spaceModelURL: nil,
        phoneNumber: .init(value: "02-970-6114"),
        precautions: "주의사항"
    )
}

extension Space {
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
}

enum SpaceValidationError: String, Error {
    case emptyName, nameTooLong, invalidSize, invalidHours, missingDays, invalidPhone, tooLongPrecautions
}

extension Space {
    var validationErrors: [SpaceValidationError] {
        var errors: [SpaceValidationError] = []
        if name?.isEmpty ?? true { errors.append(.emptyName) }
        if (name?.count ?? 0) > 100 { errors.append(.nameTooLong) }
        if (size ?? -1) <= 0 { errors.append(.invalidSize) }
        if operationInfo?.dayOfWeeks.isEmpty ?? true { errors.append(.missingDays) }
        if let op = operationInfo,
           let start = op.startAt.dateValue,
           let end = op.endAt.dateValue,
           start >= end {
            errors.append(.invalidHours)
        }
        if phoneNumber?.isValid != true { errors.append(.invalidPhone) }
        if (precautions?.count ?? 0) > 500 { errors.append(.tooLongPrecautions) }
        return errors
    }
}

extension Space {
    var allImageURLs: [URL]? {
        if resolvedSubImageURLs.isEmpty {
            return resolvedMainImageURL.map { [$0] }
        } else {
            let combined = (resolvedMainImageURL.map { [$0] } ?? []) + resolvedSubImageURLs
            return combined.isEmpty ? nil : combined
        }
    }
}
