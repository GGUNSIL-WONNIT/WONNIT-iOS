//
//  TimeRange.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation

struct TimeRange: Codable, Equatable, Hashable {
    var startAt: DateComponents
    var endAt: DateComponents
}

extension TimeRange {
    var isValid: Bool {
        guard
            let start = startAt.dateValue,
            let end = endAt.dateValue
        else {
            return false
        }
        return start < end
    }
}
