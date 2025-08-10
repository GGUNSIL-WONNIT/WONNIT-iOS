//
//  DoubleFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct IntegerFieldComponentView: View {
    let config: FormFieldBaseConfig
    
    @Binding var value: Int
    @FocusState.Binding var focusedField: String?
    
    @State private var text: String = ""
        
    private var isFocused: Bool {
        focusedField == config.id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                Text(title)
                    .body_02(.grey900)
            }
            
            ZStack(alignment: .trailing) {
                TextField(config.placeholder ?? "", text: $text)
                    .focused($focusedField, equals: config.id)
                    .keyboardType(config.keyboardType)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(config.isReadOnly ? .gray : .grey900)
                    .textInputAutocapitalization(.never)
                    .disabled(config.isReadOnly)
                    .submitLabel(config.submitLabel)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .padding(.trailing, config.suffix == nil ? 0 : 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.primaryPurple : .grey100, lineWidth: isFocused ? 1.2 : 1)
                    )
                    .onChange(of: text) { _, newText in
                        let filtered = newText.filter { $0.isNumber }
                        if let intValue = Int(filtered) {
                            value = intValue
                        } else {
                            value = 0
                        }
                        text = filtered
                    }
                    .onChange(of: focusedField) { _, newFocus in
                        if newFocus == config.id {
                            text = value == 0 ? "" : String(value)
                        } else if !isFocused {
                            text = format(value)
                        }
                    }
                    .onAppear {
                        text = value == 0 ? "" : String(value)
                    }
                
                if let suffix = config.suffix {
                    Text(suffix)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.grey900)
                        .padding(.trailing, 16)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = config.id
            }
        }
    }
    
    private func format(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? String(number)
    }
}

#Preview {
    @Previewable @State var value = 0
    @FocusState var focusedField: String?
    
    IntegerFieldComponentView(config: .init(id: "areaSize", title: "공간 크기", placeholder: "공간 크기를 입력해주세요 / 예) 12.25", suffix: "m²", isReadOnly: false, submitLabel: .done, keyboardType: .numberPad), value: $value, focusedField: $focusedField)
        .padding()
}
