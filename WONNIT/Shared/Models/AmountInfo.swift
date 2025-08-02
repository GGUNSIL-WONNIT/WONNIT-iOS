//
//  AmountInfo.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

struct AmountInfo: Equatable, Codable {
    enum TimeUnit: String, Codable {
        case perHour = "PER_HOUR"
        case perDay = "PER_DAY"
    }

    var timeUnit: TimeUnit
    var amount: Int
}
