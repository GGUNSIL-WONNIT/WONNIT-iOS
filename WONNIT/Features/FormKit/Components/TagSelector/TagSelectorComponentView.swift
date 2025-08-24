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
    
    @State private var showTooltip: Bool = false
    
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
                    .id(suggestedTags)
                    .opacity(showTooltip ? 1 : 0)
                    .offset(y: showTooltip ? 0 : -8)
                    .scaleEffect(showTooltip ? 1.0 : 0.98, anchor: .top)
                    .animation(.spring(), value: showTooltip)
                    .onAppear {
                        withAnimation {
                            showTooltip = true
                        }
                    }
                    .onChange(of: suggestedTags) {
                        showTooltip = false
                        DispatchQueue.main.async {
                            withAnimation { showTooltip = true }
                        }
                    }
                    Spacer()
                }
                .onChange(of: store.textValues[config.spaceCategoryFormComponentKey ?? ""]) {
                    if getTooltipText() == nil {
                        withAnimation { showTooltip = false }
                    }
                }
            }
        }
    }
    
    private func getTooltipText() -> String? {
        guard let key = config.spaceCategoryFormComponentKey,
              let category = store.textValues[key],
              !category.isEmpty else {
            return nil
        }
        
        switch category {
        case "소극장·전시":
            return "무대, 조명, 관객석, 스피커"
        case "스터디룸":
            return "책상, 의자, 화이트보드, 모니터, 콘센트"
        case "창작공방":
            return "이젤, 책상, 물레, 공구벽"
        case "음악연습실":
            return "피아노, 스피커, 마이크, 의자"
        case "댄스연습실":
            return "거울, 에어컨, 스피커, 조명"
        default:
            return nil
        }
    }
}
