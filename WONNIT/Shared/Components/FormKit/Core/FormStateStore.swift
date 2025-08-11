//
//  FocusStateStore.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

@Observable
final class FormStateStore: NSObject {
    var focusedID: String? = nil
    var fieldIDs: [String] = []
    
    func focus(_ id: String?) { focusedID = id }
    func blur() { focusedID = nil }
    
    func focusPrevious() {
        guard let currentID = focusedID, let currentIndex = fieldIDs.firstIndex(of: currentID) else { return }
        let prevIndex = (currentIndex - 1 + fieldIDs.count) % fieldIDs.count
        focus(fieldIDs[prevIndex])
    }
    
    func focusNext() {
        guard let currentID = focusedID, let currentIndex = fieldIDs.firstIndex(of: currentID) else { return }
        let nextIndex = (currentIndex + 1) % fieldIDs.count
        focus(fieldIDs[nextIndex])
    }
    
    @objc func handlePrev() { focusPrevious() }
    @objc func handleNext() { focusNext() }
    @objc func handleDone() { blur() }
    
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
