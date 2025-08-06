//
//  FormRenderer.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

struct FormRenderer {
    @ViewBuilder
    static func render(
        _ component: FormComponent,
        store: FormStateStore,
        focusedField: FocusState<String?>.Binding
    ) -> some View {
        switch component {
            
            // MARK: - Text Field
        case let .textField(config):
            TextFieldComponentView(
                id: config.id,
                title: config.title,
                placeholder: config.placeholder,
                suffix: config.suffix,
                text: store.binding(for: config.id),
                focusedField: focusedField
            )
            .onChange(of: focusedField.wrappedValue) { _, new in
                store.focusedID = new
            }
            .onAppear {
                focusedField.wrappedValue = store.focusedID
            }
            
            // MARK: - Number Field
        case let .numberField(config, formatter):
            NumberFieldComponentView(
                id: config.id,
                title: config.title,
                placeholder: config.placeholder,
                suffix: config.suffix,
                formatter: formatter,
                isReadOnly: config.isReadOnly,
                submitLabel: config.submitLabel,
                keyboardType: config.keyboardType,
                value: store.binding(for: config.id, default: 0.0),
                focusedField: focusedField
            )
            .onChange(of: focusedField.wrappedValue) { _, new in
                store.focusedID = new
            }
            
            // MARK: - Multi-line Text Field
        case let .multiLineTextField(config, formatter):
            MultiLineTextFieldComponentView(
                id: config.id,
                title: config.title,
                placeholder: config.placeholder,
                characterLimit: nil,
                text: store.binding(for: config.id),
                focusedField: focusedField,
            )
            .onChange(of: focusedField.wrappedValue) { _, new in
                store.focusedID = new
            }
            
            // MARK: - Select
        case let .select(config, options):
            DropdownSelectorComponentView(
                id: config.id,
                title: config.title,
                placeholder: config.placeholder,
                options: options,
                suffix: config.suffix,
                selected: store.binding(for: config.id),
                focusedField: focusedField
            )
            
            // MARK: - Image Uploader
        case let .imageUploader(config, variant):
            ImageUploaderComponentView(
                id: config.id,
                title: config.title,
                variant: variant,
                images: store.imageBinding(for: config.id),
                focusedField: focusedField
            )
            
            // MARK: - Day Picker
        case let .dayPicker(config):
            Text("⚠️ Not Implemented")
//            DayPickerComponentView(
//                id: id,
//                title: title,
//                selectedDate: store.binding(for: id)
//            )
            
            // MARK: - Time Picker
        case let .timePicker(config):
            Text("⚠️ Not Implemented")
//            TimePickerComponentView(
//                id: id,
//                title: title,
//                selectedTime: store.binding(for: id)
//            )
            
            // MARK: - Scanner
        case let .scannerView(id):
            Text("⚠️ Not Implemented")
//            ScannerComponentView(id: id)
            
            // MARK: - Description
        case let .description(id, text):
            Text("⚠️ Not Implemented")
//            DescriptionComponentView(id: id, text: text)
            
            // MARK: - Pricing Field (custom component)
        case let .pricingField(config):
            Text("⚠️ Not Implemented")
//            PricingFieldComponentView(
//                id: id,
//                title: title,
//                value: store.binding(for: id)
//            )
        }
    }
}
