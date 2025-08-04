//
//  MapView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Bindable var mapViewModel: MapViewModel

    var body: some View {
        Map(position: $mapViewModel.mapCameraPosition, selection: $mapViewModel.selection) {
            ForEach(mapViewModel.spaces) { space in
                Marker(space.name ?? "N/A", coordinate: space.coordinate)
                    .tint(mapViewModel.selection == space.id ? Color.blue : Color.red)
                .tag(space.id)
            }
        }
        .onChange(of: mapViewModel.selection) {
            if mapViewModel.selection != nil {
                mapViewModel.panToSelectedSpace()
            }
        }
    }
}

#Preview {
    ExploreView()
}
