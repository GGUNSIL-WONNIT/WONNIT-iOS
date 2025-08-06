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
                 let .select(config, _),
                 let .numberField(config, _),
                 let .pricingField(config),
                 let .dayPicker(config),
                 let .timePicker(config):
                
                if config.isReadOnly { continue }
                
                guard let value = store.values[config.id]?.string,
                      !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else {
                    return false
                }
                
            case let .imageUploader(config, _):
                if let images = store.values[config.id]?.images, !images.isEmpty {
                    continue
                } else {
                    return false
                }

            case .scannerView:
                continue

            case .description:
                continue
            }
        }
        return true
    }
}
