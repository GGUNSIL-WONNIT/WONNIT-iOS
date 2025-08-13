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
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.white)
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .spaceDetailByModel(let space):
                SpaceDetailView(space: space)
                    .padding(.horizontal)
                    .padding(.bottom, -40)
                    .frame(maxWidth: .infinity)
                    .withBackButtonToolbar()
            default:
                Text("⚠️")
            }
        }
    }
    
    //    private func toggleEditMode() {
    //        withAnimation(.easeInOut) {
    //            isEditMode.toggle()
    //            if !isEditMode {
    //                selectedSpaceIDs.removeAll()
    //            }
    //        }
    //    }
    
    //    private func deleteSelectedSpaces() {
    //        withAnimation(.easeInOut) {
    //            myCreatedSpaces.removeAll { selectedSpaceIDs.contains($0.id) }
    //            selectedSpaceIDs.removeAll()
    //            if myCreatedSpaces.isEmpty {
    //                isEditMode = false
    //            }
    //        }
    //    }
    
    //    private var deleteButton: some View {
    //        Button(action: deleteSelectedSpaces) {
    //            Image(systemName: "trash")
    //                .font(.system(size: 24))
    //                .foregroundColor(.white)
    //                .padding()
    //                .background(Color.red)
    //                .clipShape(Circle())
    //        }
    //        .padding()
    //        .transition(.move(edge: .leading).combined(with: .opacity))
    //    }
}
