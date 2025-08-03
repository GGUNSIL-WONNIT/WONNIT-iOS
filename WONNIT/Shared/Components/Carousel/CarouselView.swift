//
//  CarouselView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct CarouselView<Content: View>: View {
    private let content: Content
    
    private let itemSpacing: CGFloat
    private let leadingPadding: CGFloat
    
    init(
        itemSpacing: CGFloat = 6,
        leadingPadding: CGFloat = 24,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.itemSpacing = itemSpacing
        self.leadingPadding = leadingPadding
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: itemSpacing) {
                content
            }
            .padding(.horizontal, leadingPadding)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    CarouselView(itemSpacing: 12, leadingPadding: 16) {
        ForEach(1..<5) {_ in
            Rectangle()
                .fill(.black.opacity(0.15))
                .frame(width: 288, height: 200)
        }
    }
}
