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
    @State private var tabShouldResetManager = TabShouldResetManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabManager.selectedTab) {
                    HomeView().tag(TabManager.TabBarItems.home)
                    ExploreView().tag(TabManager.TabBarItems.explore)
                    DashboardView().tag(TabManager.TabBarItems.dashboard)
                }
                
                TabBarView(
                    selectedTab: $tabManager.selectedTab,
                    onTabChanged: { tappedTab in
                        if tabManager.selectedTab == tappedTab {
                            tabShouldResetManager.triggerReset(for: tappedTab)
                        }
                        tabManager.selectedTab = tappedTab
                    })
            }
            .environment(tabManager)
            .environment(tabShouldResetManager)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
