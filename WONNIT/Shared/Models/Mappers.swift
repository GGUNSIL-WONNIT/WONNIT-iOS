//
//  Mappers.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import Foundation
import OpenAPIURLSession

extension Space {
    init(from generated: Components.Schemas.SpaceDetailResponse) {
        self.id = generated.id
        self.name = generated.name
        self.address = .init(from: generated.address)
        self.mainImageURL = generated.mainImgUrl
        self.subImageURLs = generated.subImgUrls
        self.category = .init(from: generated.category)
        self.spaceTags = generated.tags
        self.size = generated.size
        self.operationInfo = .init(from: generated.operationInfo)
        self.amountInfo = .init(from: generated.amountInfo)
        self.spaceModelURL = generated.spaceModelUrl
        self.modelThumbnailUrl = generated.modelThumbnailUrl
        self.phoneNumber = .init(from: generated.phoneNumber)
        self.precautions = generated.precautions
        self.status = .init(from: generated.status)
        self.beforeImgUrl = nil
        self.afterImgUrl = nil
        self.resultImgUrl = nil
        self.similarity = nil
    }
    
    init(from generated: Components.Schemas.RecentSpaceResponse) {
        self.id = generated.spaceId
        self.name = generated.name
        self.address = .init(from: generated.addressInfo)
        self.mainImageURL = generated.mainImgUrl
        self.subImageURLs = nil
        self.category = .init(from: generated.category)
        self.spaceTags = nil
        self.size = nil
        self.operationInfo = nil
        self.amountInfo = nil
        self.spaceModelURL = nil
        self.modelThumbnailUrl = nil
        self.phoneNumber = nil
        self.precautions = nil
        self.status = nil
        self.beforeImgUrl = nil
        self.afterImgUrl = nil
        self.resultImgUrl = nil
        self.similarity = nil
    }
    
    init(from generated: Components.Schemas.MySpaceResponse) {
        self.id = generated.spaceId
        self.name = generated.name
        self.address = .init(from: generated.addressInfo)
        self.mainImageURL = generated.mainImgUrl
        self.subImageURLs = nil
        self.category = .init(from: generated.category)
        self.spaceTags = nil
        self.size = nil
        self.operationInfo = nil
        self.amountInfo = .init(from: generated.amountInfo)
        self.spaceModelURL = nil
        self.modelThumbnailUrl = nil
        self.phoneNumber = nil
        self.precautions = nil
        self.status = .init(from: generated.status)
        self.beforeImgUrl = generated.beforeImgUrl
        self.afterImgUrl = generated.afterImgUrl
        self.resultImgUrl = generated.resultImgUrl
        self.similarity = generated.similarity
    }
    
    init(from generated: Components.Schemas.MyRentalSpaceResponse) {
        self.id = generated.spaceId
        self.name = generated.name
        self.address = .init(from: generated.addressInfo)
        self.mainImageURL = generated.mainImgUrl
        self.subImageURLs = nil
        self.category = .init(from: generated.category)
        self.spaceTags = nil
        self.size = nil
        self.operationInfo = nil
        self.amountInfo = .init(from: generated.amountInfo)
        self.spaceModelURL = nil
        self.modelThumbnailUrl = nil
        self.phoneNumber = nil
        self.precautions = nil
        self.status = .init(from: generated.status)
        self.beforeImgUrl = generated.beforeImgUrl
        self.afterImgUrl = generated.afterImgUrl
        self.resultImgUrl = generated.resultImgUrl
        self.similarity = generated.similarity
    }
    
    init(from generated: Components.Schemas.SpaceSearchResponse) {
        self.id = generated.spaceId
        self.name = generated.name
        self.address = .init(from: generated.addressInfo)
        self.mainImageURL = generated.mainImgUrl
        self.subImageURLs = nil
        self.category = .init(from: generated.category)
        self.spaceTags = nil
        self.size = nil
        self.operationInfo = nil
        self.amountInfo = .init(from: generated.amountInfo)
        self.spaceModelURL = nil
        self.modelThumbnailUrl = nil
        self.phoneNumber = nil
        self.precautions = nil
        self.status = .init(from: generated.status)
        self.beforeImgUrl = nil
        self.afterImgUrl = nil
        self.resultImgUrl = nil
        self.similarity = nil
    }
}

extension AddressInfo {
    init(from generated: Components.Schemas.AddressInfo) {
        self.address1 = generated.address1
        self.address2 = generated.address2
        self.lat = generated.lat
        self.lon = generated.lon
    }
}

extension AmountInfo {
    init(from generated: Components.Schemas.AmountInfo) {
        self.timeUnit = .init(from: generated.timeUnit)
        self.amount = Int(generated.amount)
    }
}

extension AmountInfo.TimeUnit {
    init(from generated: Components.Schemas.AmountInfo.timeUnitPayload) {
        switch generated {
        case .PER_HOUR:
            self = .perHour
        case .PER_DAY:
            self = .perDay
        }
    }
}

extension OperationalInfo {
    init(from generated: Components.Schemas.OperationalInfo) {
        self.dayOfWeeks = generated.dayOfWeeks.map { .init(from: $0) }
        
        let calendar = Calendar.current
        
        self.startAt = calendar.dateComponents([.hour, .minute], from: generated.startAt)
        
        self.endAt = calendar.dateComponents([.hour, .minute], from: generated.endAt)
    }
}

extension DayOfWeek {
    init(from generated: Components.Schemas.OperationalInfo.dayOfWeeksPayload.Element) {
        switch generated {
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

extension PhoneNumber {
    init(from generated: Components.Schemas.PhoneNumber) {
        self.value = generated.value
    }
}

extension SpaceCategory {
    init(from generated: Components.Schemas.SpaceDetailResponse.categoryPayload) {
        switch generated {
        case .SMALL_THEATER: self = .smallTheater
        case .MAKER_SPACE: self = .makerSpace
        case .MUSIC_PRACTICE_ROOM: self = .musicPracticeRoom
        case .DANCE_STUDIO: self = .danceStudio
        case .STUDY_ROOM: self = .studyRoom
        }
    }
    
    init(from generated: Components.Schemas.RecentSpaceResponse.categoryPayload) {
        switch generated {
        case .SMALL_THEATER: self = .smallTheater
        case .MAKER_SPACE: self = .makerSpace
        case .MUSIC_PRACTICE_ROOM: self = .musicPracticeRoom
        case .DANCE_STUDIO: self = .danceStudio
        case .STUDY_ROOM: self = .studyRoom
        }
    }
    
    init(from generated: Components.Schemas.MySpaceResponse.categoryPayload) {
        switch generated {
        case .SMALL_THEATER: self = .smallTheater
        case .MAKER_SPACE: self = .makerSpace
        case .MUSIC_PRACTICE_ROOM: self = .musicPracticeRoom
        case .DANCE_STUDIO: self = .danceStudio
        case .STUDY_ROOM: self = .studyRoom
        }
    }
    
    init(from generated: Components.Schemas.MyRentalSpaceResponse.categoryPayload) {
        switch generated {
        case .SMALL_THEATER: self = .smallTheater
        case .MAKER_SPACE: self = .makerSpace
        case .MUSIC_PRACTICE_ROOM: self = .musicPracticeRoom
        case .DANCE_STUDIO: self = .danceStudio
        case .STUDY_ROOM: self = .studyRoom
        }
    }
    
    init(from generated: Components.Schemas.SpaceSearchResponse.categoryPayload) {
        switch generated {
        case .SMALL_THEATER: self = .smallTheater
        case .MAKER_SPACE: self = .makerSpace
        case .MUSIC_PRACTICE_ROOM: self = .musicPracticeRoom
        case .DANCE_STUDIO: self = .danceStudio
        case .STUDY_ROOM: self = .studyRoom
        }
    }
}

extension SpaceStatus {
    init(from generated: Components.Schemas.SpaceDetailResponse.statusPayload) {
        switch generated {
        case .AVAILABLE: self = .available
        case .OCCUPIED: self = .occupied
        case .RETURN_REQUEST: self = .returnRequest
        case .RETURN_REJECTED: self = .returnRejected
        }
    }
    
    init(from generated: Components.Schemas.MySpaceResponse.statusPayload) {
        switch generated {
        case .AVAILABLE: self = .available
        case .OCCUPIED: self = .occupied
        case .RETURN_REQUEST: self = .returnRequest
        case .RETURN_REJECTED: self = .returnRejected
        }
    }
    
    init(from generated: Components.Schemas.MyRentalSpaceResponse.statusPayload) {
        switch generated {
        case .AVAILABLE: self = .available
        case .OCCUPIED: self = .occupied
        case .RETURN_REQUEST: self = .returnRequest
        case .RETURN_REJECTED: self = .returnRejected
        }
    }
    
    init(from generated: Components.Schemas.SpaceSearchResponse.statusPayload) {
        switch generated {
        case .AVAILABLE: self = .available
        case .OCCUPIED: self = .occupied
        case .RETURN_REQUEST: self = .returnRequest
        case .RETURN_REJECTED: self = .returnRejected
        }
    }
}
