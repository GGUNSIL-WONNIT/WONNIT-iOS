//
//  SpaceListView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct SpaceListView: View {
    @Environment(\.dismiss) private var dismiss
    
    let category: SpaceCategory?
    let spacesToShow: [Space] = Space.mockList
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("검색 결과 \(spacesToShow.count)개")
                    .body_04(.grey700)
                
                if spacesToShow.isEmpty {
                    NotFoundView()
                        .padding(.top, 64)
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(spacesToShow) { space in
                        NavigationLink(value: Route.spaceDetailById(space.id)) {
                            SpacePreviewCardView(
                                space: space,
                                layout: .horizontal(height: 123),
                                pricePosition: .trailing
                            )
                        }
                    }
                }
            }
            .padding(.horizontal)
            .paddedForTabBar()
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(category?.label ?? "최근 추가된 공간")
            .navigationBarTitleDisplayMode(.large)
            .withBackButtonToolbar()
        }
    }
}

#Preview {
    NavigationStack {
        SpaceListView(category: .smallTheater)
    }
}
