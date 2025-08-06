//
//  AmountInfo.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

struct AmountInfo: Equatable, Codable, Hashable {
    enum TimeUnit: String, CaseIterable, Codable {
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

extension AmountInfo.TimeUnit {
    static var allLocalizedLabels: [String] {
        Self.allCases.map { $0.localizedLabel }
    }
    
    var localizedLabel: String {
        switch self {
        case .perHour: return "시간당"
        case .perDay: return "하루당"
        }
    }
    
    static func from(label: String) -> Self? {
        Self.allCases.first { $0.localizedLabel == label }
    }
}
