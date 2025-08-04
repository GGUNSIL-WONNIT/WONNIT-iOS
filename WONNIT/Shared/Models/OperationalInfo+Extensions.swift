//
//  OperationalInfo+Extensions.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import Foundation

extension OperationalInfo {
    var formattedOperationalInfo: String {
        let days = dayOfWeeks.formattedDayRange
        let start = startAt.formattedHourMinute ?? "??:??"
        let end = endAt.formattedHourMinute ?? "??:??"
        return "\(days) \(start)–\(end)"
    }
}

extension DayOfWeek {
    var localizedLabel: String {
        switch self {
        case .MONDAY: return "월"
        case .TUESDAY: return "화"
        case .WEDNESDAY: return "수"
        case .THURSDAY: return "목"
        case .FRIDAY: return "금"
        case .SATURDAY: return "토"
        case .SUNDAY: return "일"
        }
    }
}

extension DateComponents {
    var dateValue: Date? {
        Calendar.current.date(from: self)
    }
}

extension DateComponents {
    var formattedHourMinute: String? {
        guard let hour = hour, let minute = minute else { return nil }
        return String(format: "%02d:%02d", hour, minute)
    }
}

extension Array where Element == DayOfWeek {
    var formattedDayRange: String {
        let sortedDays = self.sorted(by: { $0.rawValue < $1.rawValue })

        if sortedDays.count > 1,
           let first = sortedDays.first,
           let last = sortedDays.last,
           sortedDays == Array(DayOfWeek.allCases[first.rawValue...last.rawValue]) {
            return "\(first.localizedLabel)–\(last.localizedLabel)"
        } else {
            return sortedDays.map { $0.localizedLabel }.joined(separator: ", ")
        }
    }
}
