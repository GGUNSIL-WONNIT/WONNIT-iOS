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
    
    var calendarWeekday: Int {
        switch self {
        case .SUNDAY: return 1
        case .MONDAY: return 2
        case .TUESDAY: return 3
        case .WEDNESDAY: return 4
        case .THURSDAY: return 5
        case .FRIDAY: return 6
        case .SATURDAY: return 7
        }
    }
}

extension DateComponents {
    var dateValue: Date? {
        Calendar.current.date(from: self)
    }
    
    var formattedHourMinute: String? {
        guard let hour = hour, let minute = minute else { return nil }
        return String(format: "%02d:%02d", hour, minute)
    }
}

extension Array where Element == DayOfWeek {
    var formattedDayRange: String {
        // Sort chronologically based on the declaration order in allCases
        let sortedDays = self.sorted {
            DayOfWeek.allCases.firstIndex(of: $0)! < DayOfWeek.allCases.firstIndex(of: $1)!
        }

        if sortedDays.count > 1,
           let first = sortedDays.first,
           let last = sortedDays.last,
           let firstIndex = DayOfWeek.allCases.firstIndex(of: first),
           let lastIndex = DayOfWeek.allCases.firstIndex(of: last),
           // Check if the sorted days form a contiguous block in the week
           sortedDays.count == (lastIndex - firstIndex + 1) {
            return "\(first.localizedLabel)–\(last.localizedLabel)"
        } else {
            return sortedDays.map { $0.localizedLabel }.joined(separator: ", ")
        }
    }
}
