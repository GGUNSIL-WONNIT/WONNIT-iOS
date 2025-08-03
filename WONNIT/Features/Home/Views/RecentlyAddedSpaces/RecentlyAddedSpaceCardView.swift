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
                .placeholder { placeholderImage }
                .aspectRatio(contentMode: .fill)
                .frame(width: 158, height: 119)
                .clipped()
        } else {
            Color.gray.opacity(0.1)
                .frame(width: 158, height: 119)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                )
                .cornerRadius(8)
        }
    }
    
    private var placeholderImage: some View {
        Color.gray.opacity(0.05)
            .frame(width: 158, height: 119)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundColor(.gray.opacity(0.5))
            )
    }
    
    @ViewBuilder
    private var spaceInfo: some View {
        if let name = space.name,
           let category = space.category,
           let address = space.address?.address1 {
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(name)
                        .body_04(.grey900)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(category.label)
                        .body_06(.grey800)
                }
                
                HStack(spacing: 0) {
                    Image("icon/locationOutline")
                    Text(address)
                        .caption_03(.grey700)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    let demoSpace = Space.placeholder
    
    RecentlyAddedSpaceCardView(space: demoSpace)
}
