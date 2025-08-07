//
//  SpaceNearbyView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import SwiftUI

struct SpaceNearbyView: View {
    @State var mapViewModel: MapViewModel
    @Binding var detent: DraggableSheetDetent
    
//    let spacesToShow: [Space]
    
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
                
                if mapViewModel.spaces.isEmpty {
                    NotFoundView()
                        .padding(.top, 64)
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(mapViewModel.spaces) { space in
                        Button {
                            detent = .small
                            mapViewModel.selection = space.id
                        } label: {
                            SpacePreviewCardView(
                                space: space,
                                layout: .horizontal(height: 123),
                                pricePosition: .leading,
                                additionalTextTopRight: "500m"
                            )
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(.plain)
                    }
                }
            }
//            .padding(.top)
            .padding(.bottom, 120)
        }
    }
}
