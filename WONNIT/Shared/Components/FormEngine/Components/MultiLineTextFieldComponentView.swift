//
//  MultiLineTextFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct MultiLineTextFieldComponentView: View {
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

            ZStack(alignment: .topLeading) {
                if text.isEmpty, let placeholder = config.placeholder {
                    Text(placeholder)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                }
                
                TextEditor(text: $text)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.grey900)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.primaryPurple : .grey100, lineWidth: isFocused ? 1.2 : 1)
                    )
                    .frame(minHeight: 52, maxHeight: 130)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = config.id
                    }
            }

            if let limit = config.characterLimit {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(limit)")
                        .font(.caption)
                        .foregroundColor(text.count > limit ? .red : .gray)
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

#Preview {
    @Previewable @State var value = ""
    @FocusState var focusedField: String?
    
    MultiLineTextFieldComponentView(config: .init(id: "cautions", title: "주의사항", placeholder: "주의사항이 있다면 입력해주세요", characterLimit: 100), text: $value, focusedField: $focusedField)
        .padding()
}
