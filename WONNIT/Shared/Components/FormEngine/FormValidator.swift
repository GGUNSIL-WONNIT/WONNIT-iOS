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
                
            case let .numberField(config),
                let .pricingField(config):
                
                if config.isReadOnly { continue }
                
                guard let number = store.values[config.id]?.double, number > 0 else {
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
                
            case let .timePicker(config):
                continue
                
            case let .imageUploader(config, _):
                guard let images = store.values[config.id]?.images,
                      !images.isEmpty else {
                    return false
                }
                
            case .scannerView, .description:
                continue
            }
        }
        
        return true
    }
}
