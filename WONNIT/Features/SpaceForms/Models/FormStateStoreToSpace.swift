//
//  FormStateStoreToSpace.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import Foundation
import SwiftUI

import Foundation

extension FormStateStore {
    func toSpace(existing: Space? = nil) -> Space {
        let address1 = self.values["address1"]?.string ?? ""
        let address2 = self.values["address2"]?.string
        let name = self.values["name"]?.string
        
        let mainImageURL = self.values["mainImage"]?.images?.first?.jpegData(compressionQuality: 0.9)?.base64EncodedString()
        let subImageURLs = self.values["subImages"]?.images?.compactMap {
            $0.jpegData(compressionQuality: 0.8)?.base64EncodedString()
        }
        
        let categoryLabel = self.values["category"]?.string
        let category = SpaceCategory.allCases.first { $0.label == categoryLabel }
        
        let size = self.values["area"]?.double
        
        let dayOfWeeks = self.values["openDay"]?.decoded(as: [DayOfWeek].self) ?? []
        
        let timeRange = self.values["openTime"]?.decoded(as: TimeRange.self)
        
        let amountInfo = self.values["pricing"]?.amountInfo
        
        let phoneNumber = self.values["contact"]?.string.map { PhoneNumber(value: $0) }
        
        let precautions = self.values["cautions"]?.string
        
        return Space(
            id: existing?.id ?? UUID(),
            name: name,
            address: AddressInfo(
                address1: address1,
                address2: address2,
                lat: existing?.address?.lat,
                lon: existing?.address?.lon
            ),
            mainImageURL: mainImageURL.map { "data:image/jpeg;base64," + $0 },
            subImageURLs: subImageURLs?.map { "data:image/jpeg;base64," + $0 },
            category: category,
            spaceTags: existing?.spaceTags,
            size: size,
            operationInfo: timeRange.map {
                OperationalInfo(dayOfWeeks: dayOfWeeks, startAt: $0.startAt, endAt: $0.endAt)
            },
            amountInfo: amountInfo,
            spaceModelURL: existing?.spaceModelURL,
            phoneNumber: phoneNumber,
            precautions: precautions
        )
    }
}
