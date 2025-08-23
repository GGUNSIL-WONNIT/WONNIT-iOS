//
//  MyRentedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct MyRentedSpacesView: View {
    @Environment(AppSettings.self) private var appSettings
    
    let selectedDashboardTab: DashboardTab = .myRentedSpaces
    
    @State var spacesToShow: [Space] = Space.mockList.filter { $0.status != .available }
    
    var body: some View {
        DashboardSpaceListView(selectedDashboardTab: selectedDashboardTab, spacesToShow: $spacesToShow)
            .task {
                do {
                    self.spacesToShow = try await fetchSpaces()
                } catch {
                    print(error.localizedDescription)
                }
            }
            .onChange(of: appSettings.selectedTestUserID) {
                Task {
                    do {
                        self.spacesToShow = try await fetchSpaces()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    private func fetchSpaces() async throws -> [Space] {
        let client = try await WONNITClientAPIService.shared.client()
        let response = try await client.getRentalSpaces(query: .init(userId: appSettings.selectedTestUserID))
        let mySpaces = try response.ok.body.json
        return mySpaces.spaces.map { Space(from: $0) }
    }
}

#Preview {
    MyRentedSpacesView()
}
