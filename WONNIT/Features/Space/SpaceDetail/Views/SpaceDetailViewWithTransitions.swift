//
//  SpaceDetailViewWithTransitions.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import SwiftUI

struct SpaceDetailViewWithTransitions: View {
    let space: Space
    let detent: DraggableSheetDetent
    
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            if detent == .medium {
                SpacePreviewCardView(space: space, layout: .horizontal(height: 98), additionalTextTopRight: "500m", namespace: namespace)
            } else {
                SpaceDetailView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: detent)
    }
}
