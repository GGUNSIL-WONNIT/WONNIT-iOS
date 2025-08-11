//
//  PricingFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct PricingFieldComponentView: View {
    let config: FormFieldBaseConfig
    @Environment(FormStateStore.self) private var store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                Text(title).body_02(.grey900)
            }
            PricingFieldBridge(
                id: config.id,
                store: store,
                value: store.amountInfoBinding(for: config.id),
                style: PickerStyleColorsMapping(
                    textSelected: UIColor(Color.grey900),
                    textNormal: UIColor(Color.grey900),
                    bgSelected: UIColor(.white),
                    bgNormal: UIColor(.white),
                    borderSelected: UIColor(Color.primaryPurple),
                    borderNormal: UIColor(Color.grey100)
                ),
                unitWidth: 102,
                units: Array(AmountInfo.TimeUnit.allCases),
                onDone: { store.blur() }
            )
            .frame(height: 48)
        }
    }
}
