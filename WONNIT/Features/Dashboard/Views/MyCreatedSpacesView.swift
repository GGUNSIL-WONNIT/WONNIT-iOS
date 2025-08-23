//
//  MyCreatedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct MyCreatedSpacesView: View {
    @Environment(AppSettings.self) private var appSettings
    
    let selectedDashboardTab: DashboardTab = .myCreatedSpaces
    
    @State var spacesToShow: [Space] = Space.mockList
    
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
        let response = try await client.getMySpaces(query: .init(userId: appSettings.selectedTestUserID))
        let mySpaces = try response.ok.body.json
        return mySpaces.spaces.map { Space(from: $0) }
    }
}

#Preview {
    MyCreatedSpacesView()
}
