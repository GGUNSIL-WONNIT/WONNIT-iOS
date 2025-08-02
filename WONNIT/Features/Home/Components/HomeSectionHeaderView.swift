//
//  HomeSectionHeaderView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct HomeSectionHeaderView: View {
    @Environment(\.navigationManager) var nav
    let homeSection: HomeSections
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(homeSection.rawValue)
                    .head_01()
                    .foregroundStyle(Color.grey900)
                
                if let subtitle = homeSection.subtitle {
                    Text(subtitle)
                        .body_06()
                        .foregroundStyle(Color.grey700)
                }
            }
            
            Spacer()
            
            if let subViewHashable = homeSection.subViewHashable {
                Button {
                    nav.push(subViewHashable)
                } label: {
                    Text("전체 보기")
                        .body_06()
                        .foregroundStyle(Color.grey900)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        ForEach(HomeSections.allCases, id: \.self) {section in
            HomeSectionHeaderView(homeSection: section)
        }
        .padding()
    }
}
