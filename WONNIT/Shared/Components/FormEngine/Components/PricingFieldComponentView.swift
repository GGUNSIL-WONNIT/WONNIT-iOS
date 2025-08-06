//
//  PricingFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct PricingFieldComponentView: View {
    let id: String
    let title: String?
    
    @Binding var pricingValue: AmountInfo
    @FocusState.Binding var focusedField: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .body_02(.grey900)
            }
            HStack {
                DropdownSelectorComponentView(
                    id: "\(id).timeUnit",
                    title: nil,
                    placeholder: "단위",
                    options: AmountInfo.TimeUnit.allLocalizedLabels,
                    suffix: nil,
                    selected: timeUnitBinding,
                    focusedField: $focusedField
                )
                .frame(width: 102)
                
                IntegerFieldComponentView(
                    id: "\(id).amount",
                    title: nil,
                    placeholder: "금액",
                    suffix: "원",
                    isReadOnly: false,
                    submitLabel: .return,
                    keyboardType: .numberPad,
                    value: $pricingValue.amount,
                    focusedField: $focusedField
                )
            }
        }
    }
    
    private var timeUnitBinding: Binding<String> {
        Binding<String>(
            get: {
                pricingValue.timeUnit.localizedLabel
            },
            set: { newLabel in
                if let newUnit = AmountInfo.TimeUnit.from(label: newLabel) {
                    pricingValue.timeUnit = newUnit
                }
            }
        )
    }
}

#Preview {
    @Previewable @State var amountInfo: AmountInfo = .init(timeUnit: .perDay, amount: 10000)
    @FocusState var focusedField: String?
    
    PricingFieldComponentView(id: "Pricing", title: "금액정보", pricingValue: $amountInfo, focusedField: $focusedField)
}
