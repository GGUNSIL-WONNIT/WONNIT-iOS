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
    @State private var showCreateSpaceSheet: Bool = false
    
    @State private var isShowingLaunchScreen: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !isShowingLaunchScreen {
                    ZStack(alignment: .bottomTrailing) {
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
                                }
                            )
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        
                        if tabManager.selectedTab != .explore {
                            Button(action: {
                                showCreateSpaceSheet = true
                            }) {
                                Image(systemName: "pencil.line")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Circle().fill(Color.primaryPurple))
                                    .shadow(radius: 8)
                            }
                            .padding(.trailing, 16)
                            .paddedForTabBar()
                            .accessibilityLabel("공간 등록")
                        }
                    }
                    .environment(tabManager)
                    .environment(tabShouldResetManager)
                    .fullScreenCover(isPresented: $showCreateSpaceSheet) {
                        CreateSpaceView()
                    }
                }
                
                if isShowingLaunchScreen {
                    LaunchScreenAnimatedView(isPresented: $isShowingLaunchScreen)
                }
            }
        }
    }
}
