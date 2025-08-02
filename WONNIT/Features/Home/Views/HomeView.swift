//
//  HomeView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

struct HomeView: View {
    @State var homeNavigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $homeNavigationManager.path) {
            ScrollView {
                VStack(spacing: 0) {
//                    LogoView()
                    HeroView()
                    VStack(spacing: 48) {
                        SpaceCategoriesView()
                        RecentlyAddedSpacesView()
                    }
                }
            }
            .environment(\.navigationManager, homeNavigationManager)
        }
    }
}

#Preview {
    HomeView()
}
