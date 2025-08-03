//
//  SpaceCategoriesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct SpaceCategoriesView: View {
    @Environment(\.navigationManager) private var nav
    
    var body: some View {
        VStack(spacing: 16) {
            HomeSectionHeaderView(homeSection: .spaceCategories)
            
            HStack {
                ForEach(SpaceCategory.allCases, id: \.self) { category in
                    categoryButton(category: category)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private func categoryButton(category: SpaceCategory) -> some View {
        Button {
            nav.push(Route.spaceListByCategory(category))
        } label: {
            VStack(spacing: 8) {
                Image(category.iconName)
                
                Text(category.label)
                    .caption_02(.grey900)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    HomeView()
}
