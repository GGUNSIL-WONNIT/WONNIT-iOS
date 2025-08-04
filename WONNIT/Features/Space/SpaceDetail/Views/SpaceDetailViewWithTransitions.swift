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
                peakLayout
            } else {
                fullLayout
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: detent)
    }
    
    private var peakLayout: some View {
        HStack(spacing: 16) {
            SpaceImageView(space: space, detent: detent)
                .matchedGeometryEffect(id: "image", in: namespace)
            
            SpaceTextView(space: space, detent: detent)
                .matchedGeometryEffect(id: "text", in: namespace)
            
            Spacer()
        }
    }
    
    private var fullLayout: some View {
        VStack(spacing: 16) {
            SpaceImageView(space: space, detent: detent)
                .matchedGeometryEffect(id: "image", in: namespace)
            
            SpaceTextView(space: space, detent: detent)
                .matchedGeometryEffect(id: "text", in: namespace)
                .padding(.bottom, 4)
            
            Text("상세페이지")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
    
}
