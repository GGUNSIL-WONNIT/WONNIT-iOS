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

enum DayOfWeek: Int, Codable, Equatable, CaseIterable {
    case MONDAY = 0, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}
