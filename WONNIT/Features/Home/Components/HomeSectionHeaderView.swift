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
                    .head_01(.grey900)
                    .lineLimit(1)
                
                if let subtitle = homeSection.subtitle {
                    Text(subtitle)
                        .body_05(.grey700)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if let subViewHashable = homeSection.subViewHashable {
                Button {
                    nav.push(subViewHashable)
                } label: {
                    Text("전체 보기")
                        .body_06(.grey900)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 40) {
        ForEach(HomeSections.allCases, id: \.self) {section in
            HomeSectionHeaderView(homeSection: section)
        }
//        .padding()
    }
}
