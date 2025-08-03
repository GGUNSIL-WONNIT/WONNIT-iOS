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
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabManager.selectedTab) {
                    HomeView().tag(TabManager.TabBarItems.home)
                    ExploreView().tag(TabManager.TabBarItems.explore)
                    DashboardView().tag(TabManager.TabBarItems.dashboard)
                }
                
                TabBarView(selectedTab: $tabManager.selectedTab)
            }
            .environment(tabManager)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
