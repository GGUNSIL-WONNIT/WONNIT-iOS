//
//  WONNITApp.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

@main
struct WONNITApp: App {
    @State var selectedTab: Int = 0
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomeView().tag(0)
                    ExploreView().tag(1)
                    DashboardView().tag(2)
                }
                
                TabBarView(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
