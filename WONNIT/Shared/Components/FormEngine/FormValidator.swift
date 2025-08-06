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
                
                guard let value = store.values[config.id]?.string,
                      !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return false
                }
                
            case let .doubleField(config):
                if config.isReadOnly { continue }
                
                guard let number = store.values[config.id]?.double, number > 0 else {
                    return false
                }
                
            case let .integerField(config):
                if config.isReadOnly { continue }
                
                guard let intValue = store.values[config.id]?.int, intValue > 0 else {
                    return false
                }
                
            case let .pricingField(config):
                if config.isReadOnly { continue }
                
                guard let amountInfo = store.values[config.id]?.amountInfo else {
                    return false
                }
                
                let isValidAmount = amountInfo.amount > 0
                let isValidTimeUnit = [.perHour, .perDay].contains(amountInfo.timeUnit)
                
                guard isValidAmount && isValidTimeUnit else {
                    return false
                }
                
            case let .dayPicker(config):
                guard
                    let data = store.values[config.id]?.codableData,
                    let selectedDays = try? JSONDecoder().decode(Set<DayOfWeek>.self, from: data),
                    !selectedDays.isEmpty
                else {
                    return false
                }
                
            case let .timeRangePicker(config):
                if config.isReadOnly { continue }
                
                guard
                    let value = store.values[config.id],
                    case let .codable(data) = value,
                    let range = try? JSONDecoder().decode(TimeRange.self, from: data),
                    range.isValid
                else {
                    return false
                }
                
            case let .imageUploader(config, _):
                guard let images = store.values[config.id]?.images,
                      !images.isEmpty else {
                    return false
                }
                
            case .scannerView, .description:
                continue
                
            case let .tagSelector(config):
                continue
            }
        }
        return true
    }
}
