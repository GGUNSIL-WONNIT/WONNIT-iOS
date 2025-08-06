//
//  FormComponent.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

enum FormComponent {
    case textField(config: FormFieldBaseConfig)
    case multiLineTextField(config: FormFieldBaseConfig, characterLimit: Int? = nil)
    case doubleField(config: FormFieldBaseConfig)
    case integerField(config: FormFieldBaseConfig)
    case select(config: FormFieldBaseConfig, options: [String])
    case imageUploader(config: FormFieldBaseConfig, variant: ImageUploaderVariant)
    case dayPicker(config: FormFieldBaseConfig)
    case timeRangePicker(config: FormFieldBaseConfig)
    case pricingField(config: FormFieldBaseConfig)
    case scannerView(id: String)
    case description(id: String, text: String)
    case tagSelector(config: FormFieldBaseConfig)
}

enum ImageUploaderVariant {
    case singleLarge
    case multipleSmall(limit: Int)
}

struct FormFieldBaseConfig {
    let id: String
    let title: String?
    let placeholder: String?
    let suffix: String?
    let isReadOnly: Bool
    let submitLabel: SubmitLabel
    let keyboardType: UIKeyboardType

    init(
        id: String,
        title: String? = nil,
        placeholder: String? = nil,
        suffix: String? = nil,
        isReadOnly: Bool = false,
        submitLabel: SubmitLabel = .done,
        keyboardType: UIKeyboardType = .default
    ) {
        self.id = id
        self.title = title
        self.placeholder = placeholder
        self.suffix = suffix
        self.isReadOnly = isReadOnly
        self.submitLabel = submitLabel
        self.keyboardType = keyboardType
    }
}

extension FormComponent: Identifiable {
    var id: String {
        switch self {
        case .textField(let config),
             .multiLineTextField(let config, _),
             .doubleField(let config),
             .integerField(let config),
             .select(let config, _),
             .imageUploader(let config, _),
             .dayPicker(let config),
             .timeRangePicker(let config),
             .pricingField(let config),
             .tagSelector(let config):
            return config.id
        case .scannerView(let id),
             .description(let id, _):
            return id
        }
    }
}
