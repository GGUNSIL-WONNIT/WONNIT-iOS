//
//  DropdownSelectorComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct DropdownSelectorComponentView: View {
    let id: String
    let title: String?
    let placeholder: String?
    let options: [String]
    let suffix: String?
    let isAIFeatured: Bool

    @Binding var selected: String
    @FocusState.Binding var focusedField: String?
    
    private var isFocused: Bool {
        focusedField == id
    }

    var displayText: String {
        selected.isEmpty ? (placeholder ?? "") : selected
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = title {
                HStack(spacing: 6) {
                    Text(title)
                        .body_02(.grey900)
                    
                    if isAIFeatured {
                        GradientTagView(label: "AI추천")
                    }
                }
            }

            ZStack(alignment: .trailing) {
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            selected = option
                        }
                    }
                } label: {
                    HStack {
                        Text(displayText)
                            .font(.system(size: 16))
                            .foregroundStyle(selected.isEmpty ? .gray : .grey900)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .padding(.trailing, suffix == nil ? 0 : 48)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.primaryPurple : .grey100, lineWidth: isFocused ? 1.2 : 1)
                    )
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = id
                }

                if let suffix = suffix {
                    Text(suffix)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.grey900)
                        .padding(.trailing, 16)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selected = ""
    @FocusState var focusedField: String?
    
    DropdownSelectorComponentView(
        id: "category",
        title: "공간 카테고리",
        placeholder: "선택하세요",
        options: ["어쩌고", "저쩌고", "이러쿵", "저러쿵"],
        suffix: nil,
        isAIFeatured: true,
        selected: $selected,
        focusedField: $focusedField
    )
    .padding()
}
