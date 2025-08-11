//
//  FocusStateStore.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

@Observable
final class FormStateStore {
    var focusedID: String? = nil
    func focus(_ id: String?) { focusedID = id }
    func blur() { focusedID = nil }
    
    var textValues: [String: String] = [:]
    var doubleValues: [String: Double?] = [:]
    var intValues: [String: Int?] = [:]
    var daySetValues: [String: Set<DayOfWeek>] = [:]
    var timeRangeValues: [String: TimeRange] = [:]
    var selectValues: [String: String?] = [:]
    var tagsValues: [String: [String]] = [:]
    var amountInfoValues: [String: AmountInfo] = [:]
    var imageValues: [String: [UIImage]] = [:]
}
