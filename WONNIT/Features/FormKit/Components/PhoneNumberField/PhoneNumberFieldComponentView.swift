//
//  PhoneNumberFieldComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI

struct PhoneNumberFieldComponentView: View {
    let config: FormFieldBaseConfig
    @Environment(FormStateStore.self) private var store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = config.title { Text(title).body_02(.grey900) }
            ZStack(alignment: .trailing) {
                PhoneNumberFieldBridge(
                    id: config.id,
                    store: store,
                    text: store.stringBinding(for: config.id),
                    placeholder: config.placeholder,
                    onDone: { store.blur() }
                )
                .frame(height: 48)
                .padding(.horizontal, 12)
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
