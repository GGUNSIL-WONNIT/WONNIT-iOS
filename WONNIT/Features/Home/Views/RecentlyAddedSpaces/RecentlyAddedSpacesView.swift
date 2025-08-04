//
//  RecentlyAddedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct RecentlyAddedSpacesView: View {
    var body: some View {
        VStack(spacing: 16) {
            HomeSectionHeaderView(homeSection: .recentlyAddedSpaces)
            
//            CarouselView(itemSpacing: 16, leadingPadding: 16) {
//                ForEach (0..<5) { _ in
//                    RecentlyAddedSpaceCardView(space: .placeholder)
//                }
//            }
            
            NotFoundView()
        }
    }
}

#Preview {
    RecentlyAddedSpacesView()
}
