//
//  SpaceDetailComponentsView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import SwiftUI
import Kingfisher

struct SpaceImageView: View {
    let space: Space
    let detent: DraggableSheetDetent

    var body: some View {
        if let image = space.resolvedMainImageURL {
            if detent == .large {
                KFImage(image)
                    .cacheOriginalImage()
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(16)
                    .clipped()
            } else {
                KFImage(image)
                    .cacheOriginalImage()
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(4)
                    .clipped()
            }
        } else {
            Color.gray.opacity(0.05)
        }
    }
}

struct SpaceTextView: View {
    let space: Space
    let detent: DraggableSheetDetent

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let name = space.name {
                Text(name)
                    .title_01()
            }
            
            if let category = space.category {
                Text(category.label)
                    .body_04(.grey800)
            }
            
            if let address = space.address?.address1 {
                Text(address)
                    .caption_02(.grey700)
                    .padding(.top, 4)
            }
        }
        .scaleEffect(detent == .large ? 1.3 : 0.9, anchor: .topLeading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 64) {
        SpaceTextView(space: .placeholder, detent: .large)
        
        SpaceTextView(space: .placeholder, detent: .medium)
    }
}

#Preview {
    VStack(spacing: 64) {
        SpaceImageView(space: .placeholder, detent: .large)
        
        SpaceImageView(space: .placeholder, detent: .medium)
    }
}
