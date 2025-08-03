//
//  AddressInfo.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

struct AddressInfo: Equatable, Codable {
    var address1: String
    var address2: String?
    var lat: Double
    var lon: Double
}
