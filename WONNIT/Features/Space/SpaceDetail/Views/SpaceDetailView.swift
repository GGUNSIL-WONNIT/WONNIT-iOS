//
//  SpaceDetailView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI
import Kingfisher

struct SpaceDetailView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    let space: Space
    let namespace: Namespace.ID?
    
    let isEditable = false
    @State private var showEditSpaceForm = false
    
    @State private var isShowingUSDZPreview: Bool = false
    
    init(space: Space, namespace: Namespace.ID? = nil) {
        self.space = space
        self.namespace = namespace
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    spaceImagesCarousel
                        .padding(.horizontal)
                    
                    spaceInfoFromPreview
                        .padding(.horizontal)
                    
                    RentSpaceActionButtonView(spaceId: space.id, isAvailable: space.status == .available)
                        .padding(.horizontal)
                    
                    Rectangle()
                        .fill(Color.grey100)
                        .frame(height: 8)
                    
                    spaceInfoSection
                        .padding(.horizontal)
                    
                    Rectangle()
                        .fill(Color.grey100)
                        .frame(height: 8)
                    
                    spaceScannerSection
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            .padding(.top, safeAreaInsets.top + 44)
            
            Color.white
                .frame(height: safeAreaInsets.top + 44)
        }
        .ignoresSafeArea(.all, edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            if isEditable {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEditSpaceForm = true
                    } label: {
                        Text("수정하기")
                            .body_04(.grey900)
                            .contentShape(Rectangle())
                    }
                    .foregroundStyle(Color.grey900)
                    .font(.system(size: 18))
                }
            }
        }
        .fullScreenCover(isPresented: $showEditSpaceForm) {
            EditSpaceView(spaceData: space)
        }
        .sheet(isPresented: $isShowingUSDZPreview) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        isShowingUSDZPreview = false
                    } label: {
                        Text("완료")
                            .body_03(.grey900)
                    }
                }
                .padding(16)
                
                USDZPreviewView(url: URL(string: "https://github.com/GGUNGSIL-WONNIT/testing-USDZ-file-downloads/raw/refs/heads/main/Room.usdz")!)
            }
            .ignoresSafeArea()
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
                    .onTapGesture {
                        isShowingUSDZPreview = true
                    }
                
                HStack(spacing: 2) {
                    TooltipView(pointerPlacement: .trailing) {
                        Text("버튼을 눌러 확대해보세요")
                            .body_05(.grey100)
                    }
                    
                    Button {
                        isShowingUSDZPreview = true
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
    NavigationView {
        SpaceDetailView(space: .placeholder)
            .withBackButtonToolbar()
    }
}
