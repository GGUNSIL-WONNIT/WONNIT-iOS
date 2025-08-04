//
//  SpaceDetailView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI
import Kingfisher

struct SpaceDetailView: View {
    let space: Space
    let namespace: Namespace.ID?
    
    init(space: Space, namespace: Namespace.ID? = nil) {
        self.space = space
        self.namespace = namespace
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                spaceImagesCarousel
                
                spaceInfoFromPreview
                
                Divider()
                    .padding(.vertical, 8)
                
                spaceInfoSection
            }
        }
    }
    
    @ViewBuilder
    private var spaceImagesCarousel: some View {
        if let urls = space.allImageURLs {
            TabView {
                ForEach(urls, id: \.self) { url in
                    GeometryReader { geometry in
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.width * 0.75) // 4:3
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.width * 0.75 - 16)
            .tabViewStyle(.page)
            .matchedGeometry(id: "spaceImage-\(space.id)", in: namespace)
        } else {
            ImagePlaceholder(width: .infinity, height: 257)
        }
    }
    
    private var spaceInfoFromPreview: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                if let category = space.category?.label {
                    Text(category)
                        .body_04(.grey700)
                        .matchedGeometry(id: "spaceCategory-\(space.id)", in: namespace)
                }
                
                if let name = space.name {
                    Text(name)
                        .head_01(.grey900)
                        .matchedGeometry(id: "spaceName-\(space.id)", in: namespace)
                }
            }
            
            if let price = space.amountInfo?.amount {
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(price)원")
                        .head_02(.grey900)
                    if let unit = space.amountInfo?.timeUnit {
                        Text(unit.displayText)
                            .caption_03(.grey700)
                            .padding(.bottom, 2)
                    }
                }
                .matchedGeometry(id: "spacePrice-\(space.id)", in: namespace)
            }
        }
    }
    
    private var spaceInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - 상세 정보
            Text("상세 정보")
                .head_01(.grey900)
            
            if let coordinate = space.coordinate {
                SpaceDetailMiniMapView(spaceCoordinates: coordinate)
            }
            
            VStack(alignment: .leading, spacing: 14) {
                ForEach(space.detailInformation, id: \.self) { info in
                    HStack(spacing: 12) {
                        Image(info.iconName)
                        Text(info.content)
                            .body_04(.grey900)
                    }
                }
            }
            
            // MARK: - 룸스캔
        }
    }
}

#Preview {
    SpaceDetailView(space: .placeholder)
        .padding()
        .frame(maxWidth: .infinity)
}
