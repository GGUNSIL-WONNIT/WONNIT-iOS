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
        
        var displayText: String {
            switch self {
            case .perHour:
                return "/시간"
            case .perDay:
                return "/일"
            }
        }
    }

    var timeUnit: TimeUnit
    var amount: Int
}
