//
//  MyRentedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct MyRentedSpacesView: View {
    @Environment(AppSettings.self) private var appSettings
    @Environment(RefetchTrigger.self) private var refetchTrigger
    
    let selectedDashboardTab: DashboardTab = .myRentedSpaces
    
    @State var spacesToShow: [Space] = []
    
    var body: some View {
        DashboardSpaceListView(selectedDashboardTab: selectedDashboardTab, refetch: fetchSpaces, spacesToShow: $spacesToShow)
            .task {
                fetchSpaces()
            }
            .onChange(of: appSettings.selectedTestUserID) {
                fetchSpaces()
            }
            .onChange(of: refetchTrigger.refetchID) {
                fetchSpaces()
            }
    }
    
    private func fetchSpaces() {
        Task {
            do {
                let client = try await WONNITClientAPIService.shared.client()
                let response = try await client.getRentalSpaces(query: .init(userId: appSettings.selectedTestUserID))
                let mySpaces = try response.ok.body.json
                self.spacesToShow = mySpaces.spaces.map { Space(from: $0) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    MyRentedSpacesView()
}
