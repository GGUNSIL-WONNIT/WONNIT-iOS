//
//  DashboardView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct DashboardView: View {
    @State var dashboardNavigationManager = NavigationManager()
    @Environment(TabShouldResetManager.self) private var tabShouldResetManager
    
    @State private var selectedDashboardTab: DashboardTab = .myCreatedSpaces
    
    var body: some View {
        NavigationStack(path: $dashboardNavigationManager.path) {
            DashboardTabView(
                views: [
                    .myCreatedSpaces: AnyView(
                        MyCreatedSpacesView()
                    ),
                    .myRentedSpaces: AnyView(
                        MyRentedSpacesView()
                    )
                ],
                selection: $selectedDashboardTab
            )
            .environment(\.navigationManager, dashboardNavigationManager)
            .navigationBarBackButtonHidden()
            .toolbarBackground(Color.white)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .spaceDetailById(let spaceId):
                    SpaceDetailView(spaceId: spaceId)
                        .padding(.bottom, -40)
                        .withBackButtonToolbar()
                default:
                    Text("⚠️")
                }
            }
            .onChange(of: tabShouldResetManager.resetTriggers[.dashboard]) {
                handleTabReselect()
            }
        }
    }
    
    private func handleTabReselect() {
        if !dashboardNavigationManager.path.isEmpty {
            dashboardNavigationManager.path = NavigationPath()
        }
    }
}
