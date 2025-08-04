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
    case horizontal
}

struct SpacePreviewCardView: View {
    let space: Space
    let layout: SpacePreviewCardLayout
    
    var body: some View {
        switch layout {
        case .vertical:
            verticalLayout
        case .horizontal:
            horizontalLayout
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
    private var horizontalLayout: some View {
        HStack(spacing: 12) {
            spaceImage(width: 123, height: 123)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            spaceInfo(layout: .horizontal)
            Spacer()
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
        } else {
            ImagePlaceholder(width: width, height: height)
        }
    }

    // MARK: - Info
    @ViewBuilder
    private func spaceInfo(layout: SpacePreviewCardLayout) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let category = space.category {
                ColoredTagView(label: category.label)
            }

            if let name = space.name {
                Text(name)
                    .body_01(.grey900)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            if let address = space.address?.address1 {
                HStack(spacing: 0) {
                    Image("icon/locationOutline")
                    Text(address)
                        .body_06(.grey700)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }

            if layout == .horizontal, let price = space.amountInfo?.amount {
                Spacer()
                HStack(alignment: .bottom, spacing: 4) {
                    Spacer()
                    Text("\(price)원")
                        .body_01(.grey900)
                    if let unit = space.amountInfo?.timeUnit {
                        Text(unit.displayText)
                            .caption_03(.grey700)
                            .padding(.bottom, 2)
                    }
                }
            }
        }
        .frame(height: layout == .horizontal ? 123 : nil)
    }
}

#Preview {
    VStack(spacing: 32) {
        SpacePreviewCardView(space: .placeholder, layout: .vertical)
        SpacePreviewCardView(space: .placeholder, layout: .horizontal)
    }
}
