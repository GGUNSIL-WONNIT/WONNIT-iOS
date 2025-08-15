//
//  MyRentedSpacesView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct MyRentedSpacesView: View {
    let selectedDashboardTab: DashboardTab = .myRentedSpaces
    
    @State var spacesToShow: [Space] = Space.mockList
    
    var body: some View {
        DashboardSpaceListView(selectedDashboardTab: selectedDashboardTab, spacesToShow: $spacesToShow)
    }
}

#Preview {
    MyRentedSpacesView()
}
