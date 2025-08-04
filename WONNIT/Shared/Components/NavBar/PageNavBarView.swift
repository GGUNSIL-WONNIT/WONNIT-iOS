//
//  PageNavBarView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI

struct PageNavBarView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let isSmallTitleVisible: Bool
    let title: String
    let subtitle: String?
    
    init(isSmallTitleVisible: Bool, title: String, subtitle: String? = nil) {
        self.isSmallTitleVisible = isSmallTitleVisible
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Text(title)
                    .body_02(.grey900)
                
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundStyle(Color.grey900)
                    .font(.title2)
                    
                    Spacer()
                }
                
            }
            .frame(height: 48)
            
            VStack {
                HStack {
                    Text(title)
                        .title_01(.grey900)
                    Spacer()
                }
                .frame(height: 62)
                .opacity(isSmallTitleVisible ? 0.0 : 1.0)
                .offset(y: isSmallTitleVisible ? -20 : 0)
                .animation(.easeInOut(duration: 0.2), value: isSmallTitleVisible)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaInsets.top)
        .background(.white)
    }
}

#Preview {
    @Previewable @Environment(\.safeAreaInsets) var safeAreaInsets

    ZStack(alignment: .top) {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageNavBarView(isSmallTitleVisible: false, title: "Title")
                
                Text("뇽")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 150 + safeAreaInsets.top)
        }
    }
    .ignoresSafeArea(.all, edges: .top)
}
