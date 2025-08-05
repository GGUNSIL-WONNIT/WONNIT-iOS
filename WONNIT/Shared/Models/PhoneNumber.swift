//
//  PhoneNumber.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

struct PhoneNumber: Equatable, Codable, Hashable {
    var value: String

    var isValid: Bool {
        let pattern = #"^010-\d{4}-\d{4}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}
