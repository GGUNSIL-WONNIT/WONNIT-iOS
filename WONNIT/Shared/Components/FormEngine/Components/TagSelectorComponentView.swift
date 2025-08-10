//
//  TagSelectorComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import SwiftUI

struct TagSelectorComponentView: View {
    let id: String
    let title: String?
    let isAIFeatured: Bool
    
    @Binding var selectedTags: [String]
    @FocusState.Binding var focusedField: String?
    
    @State private var inputText: String = ""
    @State private var previousText: String = ""
    
    private var isFocused: Bool {
        focusedField == id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                HStack(spacing: 6) {
                    Text(title)
                        .body_02(.grey900)
                    
                    if isAIFeatured {
                        GradientTagView(label: "AI추천")
                    }
                }
            }
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedTags, id: \.self) { tag in
                            TagView(tag: tag) {
                                selectedTags.removeAll { $0 == tag }
                            }
                        }
                        
                        TextField("", text: $inputText)
                            .focused($focusedField, equals: id)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .submitLabel(.done)
                            .font(.system(size: 16))
                            .frame(minWidth: 40)
                            .layoutPriority(1)
                            .id("InputField")
                            .onSubmit(addTag)
                            .onChange(of: inputText) { _, newValue in
                                handleTextChange(newValue: newValue)
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.primaryPurple : .grey100, lineWidth: isFocused ? 1.2 : 1)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = id
                }
                .onChange(of: selectedTags.count + inputText.count) { _, _ in
                    scrollToEnd(proxy: proxy)
                }
            }
        }
    }
    
    
    private func handleTextChange(newValue: String) {
        if newValue.last == " " {
            addTag()
        } else if newValue.isEmpty && previousText.isEmpty && !selectedTags.isEmpty {
            selectedTags.removeLast()
        }
        previousText = newValue
    }
    
    private func addTag() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !selectedTags.contains(trimmed) else {
            inputText = ""
            return
        }
        selectedTags.append(trimmed)
        inputText = ""
    }
    
    private func scrollToEnd(proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo("InputField", anchor: .trailing)
        }
    }
}

private struct TagView: View {
    let tag: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tag)
                .body_05(.primaryPurple)
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .resizable()
                    .padding(4)
                    .foregroundStyle(Color.primaryPurple)
                    .bold()
                    .frame(width: 16, height: 16)
                    .background(.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 5.5)
        .background(RoundedRectangle(cornerRadius: 4).fill(Color.primaryPurple100))
    }
}

#Preview {
    @Previewable @State var selectedTags: [String] = ["tag1"]
    @FocusState var focusedField: String?
    
    VStack(spacing: 20) {
        TagSelectorComponentView(
            id: "TagSelector",
            title: "어쩌구",
            isAIFeatured: true,
            selectedTags: $selectedTags,
            focusedField: $focusedField
        )
        
        Spacer()
    }
    .padding()
    .onChange(of: focusedField) { _, newValue in
        print("focusedField changed to:", newValue ?? "nil")
    }
}
