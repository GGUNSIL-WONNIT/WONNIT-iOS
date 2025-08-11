//
//  FormValidator.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation

extension CreateSpaceFormStep {
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
                    // If not set, it defaults to 0, which is valid.
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
                // The time range has a valid default, so we only need to check if an explicitly set value is valid.
                if let range = store.timeRangeValues[config.id], !range.isValid {
                    return false
                }
                
            case let .imageUploader(config, _):
                guard let images = store.imageValues[config.id], !images.isEmpty else {
                    return false
                }
                
            case .scannerView, .description:
                continue
                
            case .tagSelector(_):
                continue
            }
        }
        return true
    }
}
