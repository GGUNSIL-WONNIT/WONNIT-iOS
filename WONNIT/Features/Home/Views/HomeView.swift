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
                    HeroView()
                    VStack(spacing: 48) {
                        SpaceCategoriesView()
                        RecentlyAddedSpacesView()
                    }
                }
            }
            .environment(\.navigationManager, homeNavigationManager)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .spaceListByCategory(let category):
                    SpaceListView(category: category)
                case .spaceListByRecent:
                    SpaceListView(category: nil)
                }
            }
        }
    }
}
