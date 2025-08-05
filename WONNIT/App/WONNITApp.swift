//
//  WONNITApp.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

@main
struct WONNITApp: App {
    @State private var tabManager = TabManager()
    @State private var shouldResetExplore = false
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabManager.selectedTab) {
                    HomeView().tag(TabManager.TabBarItems.home)
                    ExploreView(
                        shouldReset: $shouldResetExplore
                    )
                    .tag(TabManager.TabBarItems.explore)
                    DashboardView().tag(TabManager.TabBarItems.dashboard)
                }
                
                TabBarView(
                    selectedTab: $tabManager.selectedTab,
                    onTabChanged: { tappedTab in
                        if tappedTab == tabManager.selectedTab {
                            if tappedTab == .explore {
                                shouldResetExplore.toggle()
                            }
                        } else {
                            tabManager.selectedTab = tappedTab
                        }
                    })
            }
            .environment(tabManager)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
