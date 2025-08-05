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

struct Space: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String?
    let address: AddressInfo?
    let mainImageURL: String?
    let subImageURLs: [String]?
    let category: SpaceCategory?
    let spaceTags: [String]?
    let size: Double?
    let operationInfo: OperationalInfo?
    let amountInfo: AmountInfo?
    let spaceModelURL: String?
    let phoneNumber: PhoneNumber?
    let precautions: String?
    
    var coordinate: CLLocationCoordinate2D? {
        address?.coordinate
    }
}
