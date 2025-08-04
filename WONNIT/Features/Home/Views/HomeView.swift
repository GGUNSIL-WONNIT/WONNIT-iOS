//
//  HomeView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

struct HomeView: View {
    @State var homeNavigationManager = NavigationManager()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var headerOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    @State private var isScrolling: Bool = false
    @State private var scrollDebounceTask: DispatchWorkItem?
    
    private let headerHeight: CGFloat = 50
    private let headerTopPadding: CGFloat = 10
    
    private var totalHeaderHeight: CGFloat {
        safeAreaInsets.top + headerTopPadding + headerHeight
    }
    
    var body: some View {
        NavigationStack(path: $homeNavigationManager.path) {
            ZStack(alignment: .top) {
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    .zIndex(1)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: totalHeaderHeight)
                        HeroView()
                        VStack(spacing: 48) {
                            SpaceCategoriesView()
                            RecentlyAddedSpacesView()
                            ColumnsView()
                        }
                    }
                    .paddedForTabBar()
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    handleScroll(offset: offset)
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
                
                headerView()
            }
            .ignoresSafeArea(.all, edges: .top)
        }
    }

    private func handleScroll(offset: CGFloat) {
        let delta = offset - lastScrollOffset
        lastScrollOffset = offset
        
        if offset > 0 && headerOffset >= 0 {
               headerOffset = 0
               return
           }
        
        isScrolling = true
        
        let adjustedDelta = abs(delta) > 10 ? delta * 0.3 : delta
        headerOffset += adjustedDelta
        headerOffset = max(-totalHeaderHeight, min(0, headerOffset))
        
        scrollDebounceTask?.cancel()
        let task = DispatchWorkItem { [offset = headerOffset] in
            isScrolling = false
            autoCorrectHeader(from: offset)
        }
        scrollDebounceTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: task)
    }

    private func autoCorrectHeader(from offset: CGFloat) {
        let midpoint = -totalHeaderHeight / 2
        let shouldReveal = offset > midpoint
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            headerOffset = shouldReveal ? 0 : -totalHeaderHeight
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        let progress = min(1.0, max(0.0, -headerOffset / totalHeaderHeight))
        let opacity = 1.0 - progress
        
        VStack(spacing: 0) {
            Color.white
                .frame(height: safeAreaInsets.top)
            
            TypedLogoView()
                .frame(height: headerHeight)
                .padding(.top, headerTopPadding)
        }
        .frame(height: totalHeaderHeight)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .offset(y: headerOffset)
        .opacity(opacity)
        .clipped()
        .animation(isScrolling ? nil : .spring(response: 0.35, dampingFraction: 0.85), value: headerOffset)
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
