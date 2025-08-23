//
//  SpaceDetailViewWithTransitions.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import SwiftUI

struct SpaceDetailViewWithTransitions: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    let space: Space
    @Binding var detent: DraggableSheetDetent
    
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            switch detent {
            case .small:
                EmptyView()
            case .medium:
                SpacePreviewCardView(space: space, layout: .horizontal(height: 98), additionalTextTopRight: "500m", namespace: namespace)
                    .padding()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            detent = .large
                        }
                    }
            case .large:
                SpaceDetailView(spaceId: space.id, namespace: namespace)
                    .padding(.top, -1 * safeAreaInsets.top - 44)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: detent)
    }
}
