//
//  RecentlyAddedSpaceCardView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI
import Kingfisher

struct RecentlyAddedSpaceCardView: View {
    let space: Space
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            spaceImage
            spaceInfo
        }
        .frame(width: 158)
    }
    
    @ViewBuilder
    private var spaceImage: some View {
        if let urlString = space.mainImageURL,
           let url = URL(string: urlString) {
            KFImage(url)
                .resizable()
                .placeholder {
                    ImagePlaceholder(width: 158, height: 119)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 158, height: 119)
                .clipped()
        } else {
            ImagePlaceholder(width: 158, height: 119)
        }
    }
    
    @ViewBuilder
    private var spaceInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let name = space.name {
                Text(name)
                    .body_04(.grey900)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            if let category = space.category {
                Text(category.label)
                    .body_06(.grey800)
            }
            
            if let address = space.address?.address1 {
                HStack(spacing: 0) {
                    Image("icon/locationOutline")
                    Text(address)
                        .caption_03(.grey700)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
    }
}

#Preview {
    let demoSpace = Space.placeholder
    
    RecentlyAddedSpaceCardView(space: demoSpace)
}
