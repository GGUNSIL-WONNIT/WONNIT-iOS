//
//  HeroCTAButtonView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct HeroCTAButtonView: View {
    @Environment(TabManager.self) private var tab
    
    var body: some View {
        Button(action: {
            tab.selectedTab = .explore
        }) {
            HStack(spacing: 2) {
                Text("내 주변 공간 보러가기")
                    .body_06()
                    .foregroundStyle(Color.grey900)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.grey900)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HeroCTAButtonView()
}
