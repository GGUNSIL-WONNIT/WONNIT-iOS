//
//  TabBarView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Binding var selectedTab: TabManager.TabBarItems
    
    let onTabChanged: (TabManager.TabBarItems) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabManager.TabBarItems.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.bottom, safeAreaInsets.bottom - 18)
        .padding(.horizontal, 40)
        .background(Color.white)
        .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
        .shadow(color: .black.opacity(0.18), radius: 4, y: 4)
    }
    
    @ViewBuilder
    private func tabButton(for tab: TabManager.TabBarItems) -> some View {
        let isSelected = selectedTab == tab
        
        Button {
            withAnimation {
                onTabChanged(tab)
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.iconNameSelected : tab.iconName)
                    .font(.system(size: 24))
                
                Text(tab.label)
                    .font(.custom(isSelected ? "Pretendard-SemiBold" : "Pretendard-Regular", size: 14))
                    .lineSpacing(7)
            }
            .foregroundStyle(isSelected ? Color.primaryPurple : Color.grey300)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
