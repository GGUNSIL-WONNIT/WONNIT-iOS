//
//  AddressInfo.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation
import CoreLocation

struct AddressInfo: Equatable, Codable {
    var address1: String
    var address2: String?
    var lat: Double?
    var lon: Double?
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = lat, let lon = lon else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
