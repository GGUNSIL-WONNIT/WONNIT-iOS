//
//  SpacePreviewCardView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI
import Kingfisher

enum SpacePreviewCardLayout {
    case vertical
    case horizontal(height: CGFloat)
}

extension SpacePreviewCardLayout {
    var isHorizontal: Bool {
        if case .horizontal = self { return true }
        return false
    }
}

enum SpacePreviewCardPricePosition {
    case leading, trailing, none
}

struct SpacePreviewCardView: View {
    let space: Space
    let layout: SpacePreviewCardLayout
    let pricePosition: SpacePreviewCardPricePosition
    let additionalTextTopRight: String?
    let namespace: Namespace.ID?
    
    init(space: Space, layout: SpacePreviewCardLayout, pricePosition: SpacePreviewCardPricePosition = .none, additionalTextTopRight: String? = nil, namespace: Namespace.ID? = nil) {
        self.space = space
        self.layout = layout
        self.pricePosition = pricePosition
        self.additionalTextTopRight = additionalTextTopRight
        self.namespace = namespace
    }
    
    var body: some View {
        switch layout {
        case .vertical:
            verticalLayout
                .contentShape(Rectangle())
        case .horizontal(let height):
            horizontalLayout(for: height)
                .contentShape(Rectangle())
        }
    }
    
    // MARK: - Vertical Layout
    private var verticalLayout: some View {
        VStack(alignment: .leading, spacing: 8) {
            spaceImage(width: 168, height: 125)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            spaceInfo(layout: .vertical)
        }
        .frame(width: 168)
    }
    
    // MARK: - Horizontal Layout
    private func horizontalLayout(for size: CGFloat) -> some View {
        HStack(spacing: 12) {
            spaceImage(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            spaceInfo(layout: .horizontal(height: size))
        }
    }
    
    // MARK: - Image
    @ViewBuilder
    private func spaceImage(width: CGFloat, height: CGFloat) -> some View {
        if let urlString = space.mainImageURL,
           let url = URL(string: urlString) {
            KFImage(url)
                .resizable()
                .placeholder {
                    ImagePlaceholder(width: width, height: height)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipped()
                .matchedGeometry(id: "spaceImage-\(space.id)", in: namespace)
        } else {
            ImagePlaceholder(width: width, height: height)
        }
    }

    // MARK: - Info
    @ViewBuilder
    private func spaceInfo(layout: SpacePreviewCardLayout) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack() {
                if let category = space.category {
                    ColoredTagView(label: category.label)
                        .matchedGeometry(id: "spaceCategory-\(space.id)", in: namespace)
                }
                Spacer()
                if let additionalTextTopRight {
                    Text(additionalTextTopRight)
                        .body_06(.grey700)
                }
            }

            if let name = space.name {
                Text(name)
                    .body_01(.grey900)
                    .lineLimit(layout.isHorizontal ? 2 : 1)
                    .truncationMode(.tail)
                    .matchedGeometry(id: "spaceName-\(space.id)", in: namespace)
            }

            if let address = space.address?.address1 {
                HStack(spacing: 0) {
                    Image("icon/locationOutline")
                    Text(address)
                        .body_06(.grey700)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .matchedGeometry(id: "spaceAddress-\(space.id)", in: namespace)
                }
            }
            
            if layout.isHorizontal {
                Spacer()
            }

            if pricePosition != .none, let price = space.amountInfo?.amount {
                HStack {
                    if pricePosition == .trailing {
                        Spacer()
                    }
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(price)원")
                            .body_01(.grey900)
                        if let unit = space.amountInfo?.timeUnit {
                            Text(unit.displayText)
                                .caption_03(.grey700)
                                .padding(.bottom, 2)
                        }
                    }
                    .matchedGeometry(id: "spacePrice-\(space.id)", in: namespace)
                    if pricePosition == .leading {
                        Spacer()
                    }
                }
            }
        }
        .frame(height: {
            if case let .horizontal(height) = layout {
                return height
            } else {
                return nil
            }
        }())
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                SpacePreviewCardView(space: .placeholder, layout: .vertical)
                SpacePreviewCardView(space: .placeholder, layout: .horizontal(height: 123), pricePosition: .trailing)
                SpacePreviewCardView(space: .placeholder, layout: .horizontal(height: 98), pricePosition: .none, additionalTextTopRight: "500m")
                SpacePreviewCardView(space: .placeholder, layout: .horizontal(height: 123), pricePosition: .leading, additionalTextTopRight: "500m")
            }
            .padding()
        }
        .navigationTitle("노동")
    }
}
