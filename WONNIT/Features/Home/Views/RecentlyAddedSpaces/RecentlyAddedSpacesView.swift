//
//  RecentlyAddedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct RecentlyAddedSpacesView: View {
    let spacesToShow: [Space] = Array(Space.mockList.prefix(5))
    
    var body: some View {
        VStack(spacing: 16) {
            HomeSectionHeaderView(homeSection: .recentlyAddedSpaces)
            
            if spacesToShow.isEmpty {
                NotFoundView()
                    .frame(maxWidth: .infinity)
            } else {
                CarouselView(itemSpacing: 16, leadingPadding: 16) {
                    ForEach(spacesToShow) { space in
                        NavigationLink(value: Route.spaceDetailByModel(space: space)) {
                            SpacePreviewCardView(space: space, layout: .vertical)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecentlyAddedSpacesView()
}
