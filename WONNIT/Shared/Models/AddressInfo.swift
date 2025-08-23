//
//  AddressInfo.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation
import CoreLocation

struct AddressInfo: Equatable, Codable, Hashable {
    var address1: String
    var address2: String?
    var lat: Double
    var lon: Double
    
    var coordinate: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
