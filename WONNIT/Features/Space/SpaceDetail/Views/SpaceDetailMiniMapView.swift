//
//  SpaceDetailMiniMapView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI
import MapKit

struct SpaceDetailMiniMapView: View {
    let spaceCoordinates: CLLocationCoordinate2D
    
    private var cameraPosition: MapCameraPosition {
        .camera(MapCamera(
            centerCoordinate: spaceCoordinates,
            distance: 800,
            heading: 0,
            pitch: 40
        ))
    }
    
    var body: some View {
        Map(initialPosition: cameraPosition) {
            Marker("", coordinate: spaceCoordinates)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .disabled(true)
    }
}

#Preview {
    let placeholder = Space.placeholder
    if let coordinate = placeholder.coordinate {
        SpaceDetailMiniMapView(spaceCoordinates: coordinate)
    }
}
