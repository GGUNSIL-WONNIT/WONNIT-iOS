//
//  SpaceNearbyPeakView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import SwiftUI

struct SpaceNearbyPeakView: View {
    
    private let spacesToShow: [Space] = Space.mockList
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("가까운 공간")
                        .title_01(.grey900)
                    
                    Text("내 주변에 등록된 공간을 확인해보세요.")
                        .body_04(.grey700)
                    
                    Divider()
                        .padding(.top, 12)
                }
                
                if spacesToShow.isEmpty {
                    NotFoundView()
                        .padding(.top, 64)
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(spacesToShow) { space in
                        NavigationLink(value: Route.spaceDetailByModel(space: space)) {
                            SpacePreviewCardView(
                                space: space,
                                layout: .horizontal(height: 123),
                                pricePosition: .trailing
                            )
                        }
                    }
                }
            }
//            .padding(.top)
            .padding(.bottom, 120)
        }
    }
}

#Preview {
    SpaceNearbyPeakView()
        .padding()
}
