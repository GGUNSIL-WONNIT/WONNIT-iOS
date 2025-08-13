//
//  SpaceFormModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import Foundation

struct SpaceFormModel {
    var name: String = ""
    var address: AddressInfo? = nil
    var mainImageURL: String? = nil
    var subImageURLs: [String]? = nil
    var category: SpaceCategory? = nil
    var spaceTags: [String]? = nil
    var size: Double? = nil
    var operationInfo: OperationalInfo? = nil
    var amountInfo: AmountInfo? = nil
    var spaceModelURL: String? = nil
    var phoneNumber: PhoneNumber? = nil
    var precautions: String? = nil
    
    init(from space: Space) {
        self.name = space.name ?? ""
        self.address = space.address
        self.mainImageURL = space.mainImageURL
        self.subImageURLs = space.subImageURLs
        self.category = space.category
        self.spaceTags = space.spaceTags
        self.size = space.size
        self.operationInfo = space.operationInfo
        self.amountInfo = space.amountInfo
        self.spaceModelURL = space.spaceModelURL
        self.phoneNumber = space.phoneNumber
        self.precautions = space.precautions
    }
}
