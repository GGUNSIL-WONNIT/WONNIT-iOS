//
//  SelectComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI

struct SelectComponentView: View {
    let config: FormFieldBaseConfig
    let options: [String]
    
    @Environment(FormStateStore.self) private var store
    @State private var height: CGFloat = 48
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                HStack(spacing: 6) {
                    Text(title).body_02(.grey900)
                    if config.isAIFeatured { GradientTagView(label: "AI추천") }
                }
            }
            
            ZStack(alignment: .trailing) {
                SelectBridge(
                    id: config.id,
                    store: store,
                    options: options,
                    selection: store.stringBinding(for: config.id, default: "").projectedToNonOptional(),
                    placeholder: config.placeholder,
                    readOnly: config.isReadOnly,
                    onPrev: { /* store.previous() */ },
                    onNext: { /* store.next() */ },
                    onDone: { store.blur() }
                )
                .frame(height: height)
                .opacity(0.01)
                
                HStack {
                    Text(displayText)
                        .font(.system(size: 16))
                        .foregroundStyle(currentValue.isEmpty ? .gray : .grey900)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14, weight: .medium))
                }
                .allowsHitTesting(false)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .padding(.trailing, config.suffix == nil ? 0 : 48)
                
                if let suffix = config.suffix {
                    Text(suffix)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.grey900)
                        .padding(.trailing, 16)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(store.focusedID == config.id ? Color.primaryPurple : .grey100,
                            lineWidth: store.focusedID == config.id ? 1.2 : 1)
            )
            .contentShape(Rectangle())
            .onTapGesture { store.focus(config.id) }
        }
    }
    
    private var currentValue: String {
        store.textValues[config.id] ?? ""
    }
    private var displayText: String {
        currentValue.isEmpty ? (config.placeholder ?? "") : currentValue
    }
}

private extension Binding where Value == String {
    func projectedToNonOptional() -> Binding<String> { self }
}
