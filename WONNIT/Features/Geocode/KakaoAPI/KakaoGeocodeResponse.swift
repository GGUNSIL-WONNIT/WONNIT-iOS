//
//  KakaoGeocodeResponse.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/17/25.
//

import Foundation
import CoreLocation

struct KakaoGeocodeResponse: Codable {
    let documents: [Document]
}

struct Document: Codable {
    let addressName: String
    let x, y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case x, y
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lon = Double(x), let lat = Double(y) else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
