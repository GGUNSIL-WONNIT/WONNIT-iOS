//
//  Mappers+Encodable.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25
//

import Foundation
import OpenAPIURLSession

extension Components.Schemas.SpaceSaveRequest {
    init(from space: Space) throws {
        guard let category = space.category else { throw MappingError.missingRequiredData(field: "Category") }
        guard let name = space.name else { throw MappingError.missingRequiredData(field: "Name") }
        guard let phoneNumber = space.phoneNumber else { throw MappingError.missingRequiredData(field: "Phone Number") }
        guard let mainImgUrl = space.mainImageURL else { throw MappingError.missingRequiredData(field: "Main Image") }
        guard let subImgUrls = space.subImageURLs else { throw MappingError.missingRequiredData(field: "Sub Images") }
        guard let address = space.address else { throw MappingError.missingRequiredData(field: "Address") }
        guard let amountInfo = space.amountInfo else { throw MappingError.missingRequiredData(field: "Amount Info") }
        guard let size = space.size else { throw MappingError.missingRequiredData(field: "Size") }
        guard let operationInfo = space.operationInfo else { throw MappingError.missingRequiredData(field: "Operation Info") }
        guard let tags = space.spaceTags else { throw MappingError.missingRequiredData(field: "Tags") }
        
        self.init(
            category: .init(from: category),
            name: name,
            phoneNumber: phoneNumber.value,
            mainImgUrl: mainImgUrl,
            subImgUrls: subImgUrls,
            address: .init(from: address),
            amountInfo: .init(from: amountInfo),
            size: size,
            operationInfo: .init(from: operationInfo),
            spaceModelUrl: space.spaceModelURL,
            precautions: space.precautions,
            modelThumbnailUrl: space.modelThumbnailUrl,
            tags: tags
        )
    }
}

extension Components.Schemas.AddressInfo {
    init(from address: AddressInfo) {
        self.init(
            address1: address.address1,
            address2: address.address2,
            lat: address.lat,
            lon: address.lon
        )
    }
}

extension Components.Schemas.AmountInfo {
    init(from amount: AmountInfo) {
        self.init(
            timeUnit: .init(from: amount.timeUnit),
            amount: Int64(amount.amount)
        )
    }
}

extension Components.Schemas.AmountInfo.timeUnitPayload {
    init(from timeUnit: AmountInfo.TimeUnit) {
        switch timeUnit {
        case .perHour:
            self = .PER_HOUR
        case .perDay:
            self = .PER_DAY
        }
    }
}

extension Components.Schemas.OperationalInfo {
    init(from opInfo: OperationalInfo) {
        self.init(
            dayOfWeeks: opInfo.dayOfWeeks.map { .init(from: $0) },
            startAt: Calendar.current.date(from: opInfo.startAt) ?? Date(),
            endAt: Calendar.current.date(from: opInfo.endAt) ?? Date()
        )
    }
}

extension Components.Schemas.OperationalInfo.dayOfWeeksPayloadPayload {
    init(from day: DayOfWeek) {
        switch day {
        case .MONDAY: self = .MONDAY
        case .TUESDAY: self = .TUESDAY
        case .WEDNESDAY: self = .WEDNESDAY
        case .THURSDAY: self = .THURSDAY
        case .FRIDAY: self = .FRIDAY
        case .SATURDAY: self = .SATURDAY
        case .SUNDAY: self = .SUNDAY
        }
    }
}

extension Components.Schemas.SpaceSaveRequest.categoryPayload {
    init(from category: SpaceCategory) {
        switch category {
        case .smallTheater: self = .SMALL_THEATER
        case .makerSpace: self = .MAKER_SPACE
        case .musicPracticeRoom: self = .MUSIC_PRACTICE_ROOM
        case .danceStudio: self = .DANCE_STUDIO
        case .studyRoom: self = .STUDY_ROOM
        }
    }
}

enum MappingError: Error, LocalizedError {
    case missingRequiredData(field: String)
    case invalidData(field: String, value: String)
    
    var errorDescription: String? {
        switch self {
        case .missingRequiredData(let field):
            return "필수 항목이 누락되었습니다: \(field)."
        case .invalidData(let field, let value):
            return "'\(field)' 항목의 값이 잘못되었습니다: '\(value)'."
        }
    }
}
