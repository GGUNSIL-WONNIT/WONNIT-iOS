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
    ) -> some View {
        switch component {
        case let .textField(config):
            TextFieldComponentView(config: config)
                .environment(store)
        case let .doubleField(config):
            DoubleFieldComponentView(config: config)
                .environment(store)
        case let .integerField(config):
            IntegerFieldComponentView(config: config)
                .environment(store)
        case let .select(config, options):
            SelectComponentView(config: config, options: options)
                .environment(store)
        case let .dayPicker(config):
            DayPickerComponentView(config: config)
                .environment(store)
        case let .timeRangePicker(config):
            TimeRangePickerComponentView(config: config)
                .environment(store)
        case let .pricingField(config):
            PricingFieldComponentView(config: config)
                .environment(store)
        case let .tagSelector(config):
            TagSelectorComponentView(config: config)
                .environment(store)
        case let .phoneNumberField(config):
            PhoneNumberFieldComponentView(config: config)
                .environment(store)
        case let .imageUploader(config, variant):
            ImageUploaderComponentView(
                config: config,
                variant: variant,
                images: store.imageBinding(for: config.id)
            )
            .environment(store)
        case let .roomScanner(config):
            RoomScannerComponentView(
                config: config,
                roomData: store.roomDataBinding(for: config.id)
            )
        default:
            Text("😭 곧.")
        }
    }
}
