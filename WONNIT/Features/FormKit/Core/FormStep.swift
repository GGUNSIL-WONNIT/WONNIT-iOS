//
//  FormStep.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import Foundation

protocol FormStep: CaseIterable, Identifiable, Equatable where AllCases: RandomAccessCollection, Self.ID == String {
    var sectionTitle: String { get }
    var isOptional: Bool { get }
    var components: [FormComponent] { get }
    
    var next: Self? { get }
    var previous: Self? { get }
    
    func isStepValid(store: FormStateStore) -> Bool
    
    var buttons: [FormStepButton]? { get }
    var submitButtonTitle: String { get }
}

extension FormStep {
    var id: String { String(describing: self) }
    
    var next: Self? {
        let allCases = Self.allCases
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }
        let nextIndex = allCases.index(after: currentIndex)
        guard nextIndex < allCases.endIndex else { return nil }
        return allCases[nextIndex]
    }
    
    var previous: Self? {
        let allCases = Self.allCases
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }
        guard currentIndex != allCases.startIndex else { return nil }
        let previousIndex = allCases.index(before: currentIndex)
        return allCases[previousIndex]
    }
    
    func isStepValid(store: FormStateStore) -> Bool {
        for component in components {
            switch component {
            case let .textField(config),
                let .multiLineTextField(config, _),
                let .select(config, _):
                if config.isReadOnly { continue }
                guard let value = store.textValues[config.id], !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return false
                }
                
            case let .phoneNumberField(config):
                if config.isReadOnly { continue }
                guard let value = store.textValues[config.id], value.filter(\.isNumber).count >= 10 else {
                    return false
                }
                
            case let .doubleField(config):
                if config.isReadOnly { continue }
                guard let number = store.doubleValues[config.id], let unwrapped = number, unwrapped > 0 else {
                    return false
                }
                
            case let .integerField(config):
                if config.isReadOnly { continue }
                guard let intValue = store.intValues[config.id], let unwrapped = intValue, unwrapped > 0 else {
                    return false
                }
                
            case let .pricingField(config):
                if config.isReadOnly { continue }
                guard let amountInfo = store.amountInfoValues[config.id] else {
                    continue
                }
                let isValidAmount = amountInfo.amount >= 0
                guard isValidAmount else {
                    return false
                }
                
            case let .dayPicker(config):
                guard let selectedDays = store.daySetValues[config.id], !selectedDays.isEmpty else {
                    return false
                }
                
            case let .timeRangePicker(config):
                if config.isReadOnly { continue }
                if let range = store.timeRangeValues[config.id], !range.isValid {
                    return false
                }
                
            case let .imageUploaderSimple(config):
                guard let images = store.imageValues[config.id], !images.isEmpty else {
                    return false
                }
                
            case let .imageUploaderWithML(config, _):
                guard let images = store.imageValues[config.id], !images.isEmpty else {
                    return false
                }
                
            case .roomScanner(_):
                continue
                
            case .description:
                continue
                
            case .tagSelector(_):
                continue
            }
        }
        return true
    }
    
    var isOptional: Bool { false }
    var buttons: [FormStepButton]? { nil }
    var submitButtonTitle: String { "등록하기" }
}
