//
//  TextFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct TextFieldComponentView: View {
    let config: FormFieldBaseConfig
    @Environment(FormStateStore.self) private var store
    @State private var dummy: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = config.title { Text(title).body_02(.grey900) }
            ZStack(alignment: .trailing) {
                TextFieldBridge(
                    id: config.id,
                    store: store,
                    text: store.stringBinding(for: config.id),
                    placeholder: config.placeholder,
                    isSecure: false,
                    keyboard: config.keyboardType,
                    returnKey: .next,
                    submitLabel: .next,
                    readOnly: config.isReadOnly,
                    characterLimit: config.characterLimit,
                    onDone: { store.blur() }
                )
                .frame(height: 48)
                .padding(.horizontal, 12)
                
                if let suffix = config.suffix {
                    Text(suffix).font(.system(size: 16)).padding(.trailing, 16)
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

}
