//
//  FormRendererOld.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

struct FormRendererOld {
    @ViewBuilder
    static func render(
        _ component: FormComponentOld,
        store: FormStateStore,
        focusedField: FocusState<String?>.Binding
    ) -> some View {
        switch component {
            
            // MARK: - Text Field
        case let .textField(config):
            TextFieldComponentView(
                config: config,
                text: store.binding(for: config.id),
                focusedField: focusedField
            )
            
            // MARK: - Number Field
        case let .doubleField(config):
            DoubleFieldComponentView(
                config: config,
                value: store.binding(for: config.id, default: 0.0),
                focusedField: focusedField
            )
            
        case let .integerField(config):
            IntegerFieldComponentView(
                config: config,
                value: store.binding(for: config.id, default: 0),
                focusedField: focusedField
            )
            
            // MARK: - Multi-line Text Field
        case let .multiLineTextField(config, _):
            MultiLineTextFieldComponentView(
                config: config,
                text: store.binding(for: config.id),
                focusedField: focusedField,
            )
            
            // MARK: - Select
        case let .select(config, options):
            DropdownSelectorComponentView(
                config: config,
                options: options,
                selected: store.binding(for: config.id),
                focusedField: focusedField
            )
            
            // MARK: - Image Uploader
        case let .imageUploader(config, variant):
            ImageUploaderComponentView(
                config: config,
                variant: variant,
                images: store.imageBinding(for: config.id),
                focusedField: focusedField
            )
            
            // MARK: - Day Picker
        case let .dayPicker(config):
            DayPickerComponentView(
                config: config,
                selectedDays: store.binding(for: config.id, default: []),
                focusedField: focusedField
            )
            
            // MARK: - Time Picker
        case let .timeRangePicker(config):
            TimeRangePickerComponentView(
                config: config,
                selectedTimeRange: store.binding(for: config.id, default: TimeRange(startAt: .init(hour: 9, minute: 0), endAt: .init(hour: 22, minute: 0))),
                focusedField: focusedField
            )
            
        case let .pricingField(config):
            PricingFieldComponentView(
                config: config,
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
            
        case let .tagSelector(config):
            TagSelectorComponentView(
                config: config,
                selectedTags: store.binding(for: config.id, default: [""]),
                focusedField: focusedField
            )
        }
    }
}
