//
//  TagSelectorComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import SwiftUI

struct TagSelectorComponentView: View {
    let config: FormFieldBaseConfig
    @Environment(FormStateStore.self) private var store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                HStack(spacing: 6) {
                    Text(title)
                        .body_02(.grey900)
                    
                    if config.isAIFeatured {
                        GradientTagView(label: "AI추천")
                    }
                }
            }
            
            TagSelectorBridge(
                id: config.id,
                store: store,
                tags: store.tagsBinding(for: config.id),
                placeholder: config.placeholder
            )
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(store.focusedID == config.id ? Color.primaryPurple : .grey100,
                            lineWidth: store.focusedID == config.id ? 1.2 : 1)
            )
            .contentShape(Rectangle())
        }
    }
}
