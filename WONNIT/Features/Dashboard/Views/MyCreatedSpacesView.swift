//
//  MyCreatedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct MyCreatedSpacesView: View {
    let selectedDashboardTab: DashboardTab = .myCreatedSpaces
    
    @State var spacesToShow: [Space] = Space.mockList
    
    var body: some View {
        DashboardSpaceListView(selectedDashboardTab: selectedDashboardTab, spacesToShow: $spacesToShow)
    }
}

#Preview {
    MyCreatedSpacesView()
}
