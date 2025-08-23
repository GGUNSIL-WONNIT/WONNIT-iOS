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
    
    private let namespace: Namespace.ID?
    @State private var vm: SpaceDetailViewModel
    
    init(
        spaceId: String? = nil,
        namespace: Namespace.ID? = nil
    ) {
        self._vm = State(initialValue: SpaceDetailViewModel(spaceId: spaceId))
        self.namespace = namespace
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            content
                .padding(.top, safeAreaInsets.top + 44)
            
            Color.white
                .frame(height: safeAreaInsets.top + 44)
        }
        .ignoresSafeArea(.all, edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar { editToolbar }
        .task { await vm.fetchIfNeeded() }
        .fullScreenCover(isPresented: $vm.showEditSpaceForm) {
            if let space = vm.space {
                EditSpaceView(spaceData: space)
            }
        }
        .sheet(isPresented: $vm.showUSDZPreview) {
            USDZPreviewSheet(isPresented: $vm.showUSDZPreview)
        }
    }
}

private extension SpaceDetailView {
    @ViewBuilder
    var content: some View {
        switch (vm.space, vm.errorMessage) {
        case let (.some(space), _):
            DetailBody(
                space: space,
                namespace: namespace,
                showUSDZPreview: $vm.showUSDZPreview
            )
        case (nil, .some(let message)):
            ErrorBody(message: message)
        default:
            ProgressView()
        }
    }
    
    @ToolbarContentBuilder
    var editToolbar: some ToolbarContent {
        if vm.isEditable {
            ToolbarItem(placement: .topBarTrailing) {
                Button { vm.showEditSpaceForm = true } label: {
                    Text("수정하기")
                        .body_04(.grey900)
                        .contentShape(Rectangle())
                }
                .foregroundStyle(Color.grey900)
                .font(.system(size: 18))
            }
        }
    }
}

private struct DetailBody: View {
    let space: Space
    let namespace: Namespace.ID?
    
    @Binding var showUSDZPreview: Bool
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    SpaceImagesCarousel(space: space, namespace: namespace)
                        .padding(.horizontal)
                    
                    SpaceInfoPreview(space: space)
                        .padding(.horizontal)
                    
                    RentSpaceActionButtonView(spaceId: space.id, isAvailable: space.status == .available)
                        .padding(.horizontal)
                    
                    SectionDivider()
                    
                    SpaceInfoSection(space: space)
                        .padding(.horizontal)
                    
                    SectionDivider()
                    
                    SpaceScannerSection(showUSDZPreview: $showUSDZPreview)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

private struct ErrorBody: View {
    let message: String
    
    var body: some View {
        VStack {
            ErrorMessageView(
                title: "오류 메시지",
                message: message
            )
            .padding()
            
            NotFoundView(label: "공간 정보를 불러올 수 없습니다.")
            
            Spacer()
        }
    }
}

private struct SpaceImagesCarousel: View {
    let space: Space
    let namespace: Namespace.ID?
    
    var body: some View {
        if let urls = space.allImageURLs {
            TabView {
                ForEach(urls, id: \.self) { url in
                    GeometryReader { geo in
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.width * 0.75) // 4:3
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
}

private struct SpaceInfoPreview: View {
    let space: Space
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                if let category = space.category?.label {
                    Text(category)
                        .body_04(.grey700)
                }
                if let name = space.name {
                    Text(name)
                        .head_01(.grey900)
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
            }
        }
    }
}

private struct SpaceInfoSection: View {
    let space: Space
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                            TagRow(raw: info.content)
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
}

private struct SpaceScannerSection: View {
    @Binding var showUSDZPreview: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("3D 스캔 정보")
                .head_01(.grey900)
            
            ZStack(alignment: .bottomTrailing) {
                Image("demoScan")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture { showUSDZPreview = true }
                
                HStack(spacing: 2) {
                    TooltipView(pointerPlacement: .trailing) {
                        Text("버튼을 눌러 확대해보세요")
                            .body_05(.grey100)
                    }
                    Button { showUSDZPreview = true } label: {
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
}

private struct SectionDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.grey100)
            .frame(height: 8)
    }
}

private struct TagRow: View {
    let raw: String
    var body: some View {
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

private struct USDZPreviewSheet: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Text("완료")
                        .body_03(.grey900)
                }
            }
            .padding(16)
            
            USDZPreviewView(url: URL(string: "https://github.com/GGUNGSIL-WONNIT/testing-USDZ-file-downloads/raw/refs/heads/main/Room.usdz")!)
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationView {
        SpaceDetailView(spaceId: "0198d312-f855-3efc-3f89-fc285f50fa81")
            .withBackButtonToolbar()
    }
}
