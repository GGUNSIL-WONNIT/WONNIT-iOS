//
//  DoubleFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct DoubleFieldComponentView: View {
    let config: FormFieldBaseConfig
    
    @Binding var value: Double
    @FocusState.Binding var focusedField: String?
    
    @State private var text: String = ""
    
    var formatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
    
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
                        if let parsed = Double(newText) {
                            value = parsed
                        }
                    }
                    .onChange(of: focusedField) { _, newFocus in
                        if newFocus == config.id {
                            text = String(value)
                        } else if !isFocused {
                            text = formatter.string(from: NSNumber(value: value)) ?? ""
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
}

#Preview {
    @Previewable @State var value = 0.0
    @FocusState var focusedField: String?
    
    VStack {
        
        Button {
            focusedField = "areaSize"
        } label: {
            Text("Test")
        }
        
        DoubleFieldComponentView(config: .init(id: "areaSize", title: "공간 크기", placeholder: "공간 크기를 입력해주세요 / 예) 12.25", suffix: "m²", isReadOnly: false, submitLabel: .done, keyboardType: .decimalPad), value: $value, focusedField: $focusedField)
            .padding()
    }
}
