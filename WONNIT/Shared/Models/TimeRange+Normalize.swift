//
//  TimeRange+Normalize.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import Foundation

extension DateComponents {
    func withNormalizedHM() -> DateComponents {
        var c = self
        c.second = 0
        c.nanosecond = 0
        return c
    }
}

extension TimeRange {
    func withNormalizedHM() -> TimeRange {
        .init(startAt: startAt.withNormalizedHM(), endAt: endAt.withNormalizedHM())
    }
    
    func orderedNonDecreasing() -> TimeRange {
        guard let s = startAt.dateValue, let e = endAt.dateValue else { return self }
        return (s <= e) ? self : .init(startAt: startAt, endAt: startAt)
    }
}
