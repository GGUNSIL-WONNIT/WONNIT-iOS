//
//  ColumnCardView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI
import Kingfisher

struct ColumnCardView: View {
    let column: Column
    let cardSize = CGSize(width: 288, height: 164)
    
    @State private var showSafari = false
    
    var body: some View {
        Button {
            if let _ = column.resolvedUrl {
                showSafari.toggle()
            }
        } label: {
            ZStack(alignment: .bottomTrailing) {
                buildImage()
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(gradientOverlay)
                    .overlay(titleOverlay, alignment: .topLeading)
                
                HStack(spacing: 0) {
                    Text("칼럼보러가기")
                        .body_06()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                }
                .foregroundStyle(.white)
                .padding(14)
            }
            .sheet(isPresented: $showSafari) {
                if let url = column.resolvedUrl {
                    SafariView(url: url)
                } else {
                    EmptyView()
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func buildImage() -> some View {
        if let imageUrl = column.resolvedThumbnailUrl {
            KFImage(imageUrl)
                .resizable()
                .cacheOriginalImage()
                .scaledToFill()
        } else {
            ImagePlaceholder(width: cardSize.width, height: cardSize.height)
        }
    }
    
    private var gradientOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: 0x222222).opacity(0.8),
                Color(hex: 0x222222).opacity(0.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: cardSize.height)
        .cornerRadius(12)
    }
    
    private var titleOverlay: some View {
        Group {
            if let title = column.title {
                Text(title)
                    .body_01(.white)
                    .padding(20)
            }
        }
    }
}

#Preview {
    ColumnCardView(column: .placeholder)
}
