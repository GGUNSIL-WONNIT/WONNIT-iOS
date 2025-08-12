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
    case roomScanner(config: FormFieldBaseConfig)
    case description(id: String, text: String)
    case tagSelector(config: FormFieldBaseConfig)
    case phoneNumberField(config: FormFieldBaseConfig)
}

enum ImageUploaderVariant {
    case singleLarge
    case multipleSmall(limit: Int)
}

struct FormFieldBaseConfig {
    let id: String
    let title: String?
    let description: String?
    let placeholder: String?
    let suffix: String?
    let isReadOnly: Bool
    let submitLabel: SubmitLabel
    let keyboardType: UIKeyboardType
    let characterLimit: Int?
    let isAIFeatured: Bool
    let spaceCategoryFormComponentKey: String?
    let spaceTagFormComponentKey: String?

    init(
        id: String,
        title: String? = nil,
        description: String? = nil,
        placeholder: String? = nil,
        suffix: String? = nil,
        isReadOnly: Bool = false,
        submitLabel: SubmitLabel = .done,
        keyboardType: UIKeyboardType = .default,
        characterLimit: Int? = nil,
        isAIFeatured: Bool = false,
        spaceCategoryFormComponentKey: String? = nil,
        spaceTagFormComponentKey: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.placeholder = placeholder
        self.suffix = suffix
        self.isReadOnly = isReadOnly
        self.submitLabel = submitLabel
        self.keyboardType = keyboardType
        self.characterLimit = characterLimit
        self.isAIFeatured = isAIFeatured
        self.spaceCategoryFormComponentKey = spaceCategoryFormComponentKey
        self.spaceTagFormComponentKey = spaceTagFormComponentKey
    }
}

extension FormComponent: Identifiable {
    var id: String {
        switch self {
        case .textField(let config),
             .phoneNumberField(let config),
             .multiLineTextField(let config, _),
             .doubleField(let config),
             .integerField(let config),
             .select(let config, _),
             .imageUploader(let config, _),
             .dayPicker(let config),
             .timeRangePicker(let config),
             .pricingField(let config),
             .roomScanner(let config),
             .tagSelector(let config):
            return config.id
        case .description(let id, _):
            return id
        }
    }
}
