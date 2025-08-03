//
//  OperationalInfo.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

struct OperationalInfo: Equatable, Codable {
    var dayOfWeeks: [DayOfWeek]
    var startAt: DateComponents
    var endAt: DateComponents
}

enum DayOfWeek: Codable, Equatable, CaseIterable { // java.time.DayOfWeek
    case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

extension DateComponents: @retroactive Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}
