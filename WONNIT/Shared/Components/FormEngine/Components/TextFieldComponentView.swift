//
//  TextFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct TextFieldComponentView: View {
    let config: FormFieldBaseConfig
    
    @Binding var text: String
    @FocusState.Binding var focusedField: String?
    
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
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.grey900)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: config.id)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .padding(.trailing, config.suffix == nil ? 0 : 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.primaryPurple : .grey100, lineWidth: isFocused ? 1.2 : 1)
                    )
                
                if let suffix = config.suffix {
                    Text(suffix)
                        .font(.system(size: 16, weight: .regular))
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
    @Previewable @State var text = ""
    @FocusState var focusedField: String?
    
    TextFieldComponentView(config: .init(id: "1", title: "써봐", placeholder: "어쩌구", suffix: nil), text: $text, focusedField: $focusedField)
        .padding()
}
