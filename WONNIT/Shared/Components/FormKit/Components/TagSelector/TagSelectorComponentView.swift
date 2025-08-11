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
            
            if let suggestedTags = getTooltipText() {
                HStack {
                    Spacer()
                    TooltipView(pointerPlacement: .top, backgroundColor: .grey100){
                        VStack(alignment: .leading, spacing: 4) {
                            Text("다른 공간에는 이런 물건이 있어요")
                                .body_05(.grey900)
                            Text(suggestedTags)
                                .body_05(.primaryPurple)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func getTooltipText() -> String? {
        guard let key = config.tooltipContentKey,
              let category = store.textValues[key],
              !category.isEmpty else {
            return nil
        }
        
        switch category {
        case "소극장·전시":
            return "소극장·전시에 있는거"
        case "스터디룸":
            return "스터디룸에 있는거"
        case "창작공방":
            return "창작공방에 있는거"
        case "음악연습실":
            return "음악연습실에 있는거"
        case "댄스연습실":
            return "댄스연습실에 있는거"
        default:
            return nil
        }
    }
}
