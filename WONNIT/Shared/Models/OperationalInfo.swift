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

extension DateComponents {
    var dateValue: Date? {
        Calendar.current.date(from: self)
    }
}
