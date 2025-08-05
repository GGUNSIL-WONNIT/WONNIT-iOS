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
                    .padding(.vertical, 24)
                
                spaceInfoSection
                
                Divider()
                    .padding(.vertical, 24)
                
                spaceScannerSection
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
//                        .matchedGeometry(id: "spaceCategory-\(space.id)", in: namespace)
                }
                
                if let name = space.name {
                    Text(name)
                        .head_01(.grey900)
//                        .matchedGeometry(id: "spaceName-\(space.id)", in: namespace)
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
//                .matchedGeometry(id: "spacePrice-\(space.id)", in: namespace)
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
                    .padding(.bottom, 4)
            }
            
            VStack(alignment: .leading, spacing: 14) {
                ForEach(space.detailInformation, id: \.self) { info in
                    if info.id == .tags {
                        HStack(spacing: 12) {
                            Image(info.iconName)
                            tagView(from: info.content)
                        }
                    } else {
                        HStack(spacing: 12) {
                            Image(info.iconName)
                            Text(info.content)
                                .body_04(.grey900)
                        }
                    }
                }
            }
        }
    }
    
    private var spaceScannerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("3D 스캔 정보")
                .head_01(.grey900)
            
            ZStack(alignment: .bottomTrailing) {
                Image("demoScan")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                HStack(spacing: 2) {
                    TooltipView(pointerPlacement: .trailing) {
                        Text("버튼을 눌러 확대해보세요")
                            .body_05(.grey100)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "viewfinder")
                            .foregroundStyle(Color.grey700)
                            .bold()
                            .padding(9)
                            .background(Color.grey200)
                            .clipShape(Circle())
                    }
                }
                .padding(10)
            }
        }
    }
    
    @ViewBuilder
    private func tagView(from raw: String) -> some View {
        let tags = raw.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        if !tags.isEmpty {
            HStack(spacing: 4) {
                ForEach(tags, id: \.self) { tag in
                    ColoredTagView(label: tag, paddings: .init(top: 4, leading: 5, bottom: 4, trailing: 5))
                }
            }
        }
    }
}

#Preview {
    SpaceDetailView(space: .placeholder)
        .padding()
        .frame(maxWidth: .infinity)
}
