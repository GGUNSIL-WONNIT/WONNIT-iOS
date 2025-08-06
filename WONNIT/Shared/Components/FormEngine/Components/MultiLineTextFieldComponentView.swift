//
//  MultiLineTextFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct MultiLineTextFieldComponentView: View {
    let id: String
    let title: String?
    let placeholder: String?
    let characterLimit: Int?

    @Binding var text: String
    @FocusState.Binding var focusedField: String?
    
    private var isFocused: Bool {
        focusedField == id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .body_02(.grey900)
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty, let placeholder {
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
                        focusedField = id
                    }
            }

            if let limit = characterLimit {
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
    
    MultiLineTextFieldComponentView(id: "cautions", title: "주의사항", placeholder: "주의사항이 있다면 입력해주세요", characterLimit: 100, text: $value, focusedField: $focusedField)
        .padding()
}
