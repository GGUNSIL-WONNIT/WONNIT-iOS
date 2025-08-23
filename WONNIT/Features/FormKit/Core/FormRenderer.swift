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
        case let .optionalTextField(config):
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
        case let .imageUploaderSimple(config: config):
            ImageUploaderSimpleComponentView(
                config: config,
                images: store.imageBinding(for: config.id)
            )
            .environment(store)
        case let .imageUploaderWithML(config, variant):
            ImageUploaderWithMLComponentView(
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
            .environment(store)
        case let .addressPicker(config):
            AddressPickerComponentView(config: config)
                .environment(store)
        case let .imageComparison(config):
            if let before = config.spaceImagesComparisonBeforeKey, let after = config.spaceImagesComparisonAfterKey {
                ImageComparisonComponentView(
                    config: config,
                    beforeImage: store.imageBinding(for: before),
                    afterImage: store.imageBinding(for: after),
                    resultImage: store.imageBinding(for: config.id),
                    matchPct: store.doubleBinding(for: config.id)
                )
                .environment(store)
            } else {
                Text("⚠️ 이전/이후 이미지를 등록하세요.")
            }
        default:
            Text("😭 곧")
        }
    }
}
