//
//  RecentlyAddedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI
import OpenAPIURLSession

struct RecentlyAddedSpacesView: View {
    @State private var spacesToShow: [Space] = []
    
    var body: some View {
        VStack(spacing: 16) {
            HomeSectionHeaderView(homeSection: .recentlyAddedSpaces)
            
            if spacesToShow.isEmpty {
                Text("최근 추가된 공간이 없습니다.")
                    .frame(maxWidth: .infinity)
            } else {
                CarouselView(itemSpacing: 16, leadingPadding: 16) {
                    ForEach(spacesToShow) { recentSpace in
                        NavigationLink(value: Route.spaceDetailById(recentSpace.id)) {
                            SpacePreviewCardView(space: recentSpace, layout: .vertical)
                        }
                    }
                }
            }
        }
        .task {
            do {
                let client = try await WONNITClientAPIService.shared.client()
                let response = try await client.getRecentSpaces(.init())
                let recentSpaces = try response.ok.body.json
                
                self.spacesToShow = recentSpaces.map { Space(from: $0) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    RecentlyAddedSpacesView()
}
