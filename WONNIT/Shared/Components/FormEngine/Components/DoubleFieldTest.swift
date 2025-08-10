//
//  DoubleFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct DoubleFieldComponentView2: View {
    @Environment(FormStateStore.self) private var store
    
    let config: FormFieldBaseConfig
    
    @Binding var value: Double
    @State private var text: String = ""
    
    private static let nf: NumberFormatter = {
        let nf = NumberFormatter()
        nf.locale = .current
        nf.numberStyle = .decimal
        nf.usesGroupingSeparator = false
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    private var isFocused: Bool { store.focusedID == config.id }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                Text(title)
                    .body_02(.grey900)
            }
            
            ZStack(alignment: .trailing) {
                DeterministicTextField(
                    id: config.id,
                    placeholder: config.placeholder,
                    text: $text,
                    isEnabled: !config.isReadOnly,
                    keyboardType: config.keyboardType,
                    returnKeyType: .done
                )
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .padding(.trailing, config.suffix == nil ? 0 : 48)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.primaryPurple : .grey100, lineWidth: isFocused ? 1.2 : 1)
                )
                .onTapGesture { store.focus(config.id) }
                .onChange(of: text) { _, s in
                    if let n = Self.nf.number(from: s) {
                        value = n.doubleValue
                    } else {
                        let sep = Self.nf.decimalSeparator ?? "."
                        value = Double(s.replacingOccurrences(of: sep, with: ".")) ?? value
                    }
                }
                .onChange(of: store.focusedID) { _, id in
                    if id == config.id { text = raw(value) } else { text = pretty(value) }
                }
                .onAppear { text = value == 0 ? "" : pretty(value) }
                
                if let suffix = config.suffix {
                    Text(suffix)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.grey900)
                        .padding(.trailing, 16)
                }

            }
            .contentShape(Rectangle())
        }
    }
    private func raw(_ v: Double) -> String { v == floor(v) ? String(Int(v)) : String(v) }
    private func pretty(_ v: Double) -> String { Self.nf.string(from: NSNumber(value: v)) ?? String(v) }
}
