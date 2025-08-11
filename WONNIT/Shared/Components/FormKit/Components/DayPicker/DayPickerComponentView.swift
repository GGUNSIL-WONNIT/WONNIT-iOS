//
//  DayPickerComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct DayPickerComponentView: View {
    let config: FormFieldBaseConfig
    
    @Environment(FormStateStore.self) private var store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                Text(title).body_01(.grey900)
            }
            
            ZStack {
                DayPickerBridge(
                    id: config.id,
                    store: store,
                    selection: store.daysBinding(for: config.id),
                    style: PickerStyleColorsMapping(
                        textSelected: UIColor(Color.primaryPurple),
                        textNormal: UIColor(Color.grey300),
                        bgSelected: UIColor(Color.primaryPurple100),
                        bgNormal: UIColor(Color.grey100),
                        borderSelected: UIColor(Color.primaryPurple),
                        borderNormal: UIColor(Color.grey100)
                    ),
                    onPrev: { /* store.previous() */ },
                    onNext: { /* store.next() */ },
                    onDone: { store.blur() }
                )
                .frame(height: 56)
                .contentShape(Rectangle())
                .onTapGesture { store.focus(config.id) }
            }
        }
    }
}
