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
            
            // MARK: - Number Field
        case let .doubleField(config):
            DoubleFieldComponentView(
                id: config.id,
                title: config.title,
                placeholder: config.placeholder,
                suffix: config.suffix,
//                formatter: formatter,
                isReadOnly: config.isReadOnly,
                submitLabel: config.submitLabel,
                keyboardType: config.keyboardType,
                value: store.binding(for: config.id, default: 0.0),
                focusedField: focusedField
            )
            
        case let .integerField(config):
            IntegerFieldComponentView(
                id: config.id,
                title: config.title,
                placeholder: config.placeholder,
                suffix: config.suffix,
//                formatter: formatter,
                isReadOnly: config.isReadOnly,
                submitLabel: config.submitLabel,
                keyboardType: config.keyboardType,
                value: store.binding(for: config.id, default: 0),
                focusedField: focusedField
            )
            
            // MARK: - Multi-line Text Field
        case let .multiLineTextField(config, _):
            MultiLineTextFieldComponentView(
                id: config.id,
                title: config.title,
                placeholder: config.placeholder,
                characterLimit: nil,
                text: store.binding(for: config.id),
                focusedField: focusedField,
            )
            
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
            DayPickerComponentView(
                id: config.id,
                title: config.title,
                selectedDays: store.binding(for: config.id, default: []),
                focusedField: focusedField
            )
            
            // MARK: - Time Picker
        case let .timeRangePicker(config):
            TimeRangePickerComponentView(
                id: config.id,
                title: config.title,
                selectedTimeRange: store.binding(for: config.id, default: TimeRange(startAt: .init(hour: 9, minute: 0), endAt: .init(hour: 22, minute: 0))),
                focusedField: focusedField
            )
            
        case let .pricingField(config):
            PricingFieldComponentView(
                id: config.id,
                title: config.title,
                pricingValue: store.binding(for: config.id, default: AmountInfo.init(timeUnit: .perDay, amount: 10000)),
                focusedField: focusedField
            )
            
            // MARK: - Scanner
        case let .scannerView(id):
            Text("⚠️ Not Implemented")
//            ScannerComponentView(id: id)
            
            // MARK: - Description
        case let .description(id, text):
            Text("⚠️ Not Implemented")
//            DescriptionComponentView(id: id, text: text)
            
        case .donePage:
            EmptyView()
        }
    }
}
