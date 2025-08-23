//
//  FormStateStore+Inject.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import Foundation
import CoreLocation

extension FormStateStore {
    func inject(from space: Space) {
        if let address = space.address {
            addressValues["address1"] = KakaoAddress(roadAddress: address.address1, jibunAddress: "", zonecode: "")
            if let coordinate = space.coordinate {
                coordinateValues["address1"] = CLLocationCoordinate2D(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            }
            textValues["address2"] = address.address2
        }
        
        textValues["name"] = space.name
        selectValues["category"] = space.category?.label
        doubleValues["area"] = space.size
        
        if let tags = space.spaceTags {
            tagsValues["spaceTags"] = tags
        }
        
        if let operationalInfo = space.operationInfo {
            daySetValues["openDay"] = Set(operationalInfo.dayOfWeeks)
            timeRangeValues["openTime"] = .init(startAt: operationalInfo.startAt, endAt: operationalInfo.endAt)
        }
        
        if let amountInfo = space.amountInfo {
            amountInfoValues["pricing"] = amountInfo
        }
        
        textValues["contact"] = space.phoneNumber?.value ?? ""
        textValues["cautions"] = space.precautions
    }
}
