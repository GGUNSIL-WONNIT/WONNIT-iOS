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
    
    @State private var resetTimer: Timer?
    @State private var position: MapCameraPosition
    
    init(spaceCoordinates: CLLocationCoordinate2D) {
        self.spaceCoordinates = spaceCoordinates
        _position = State(initialValue: Self.defaultCamera(for: spaceCoordinates))
    }
    
    static func defaultCamera(for coord: CLLocationCoordinate2D) -> MapCameraPosition {
        .camera(MapCamera(
            centerCoordinate: coord,
            distance: 800,
            heading: 0,
            pitch: 40
        ))
    }
    
    var body: some View {
        Map(position: $position) {
            Marker("", coordinate: spaceCoordinates)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onMapCameraChange { _ in
            resetTimer?.invalidate()
            resetTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                withAnimation(.easeInOut) {
                    position = Self.defaultCamera(for: spaceCoordinates)
                }
            }
        }
    }

}

#Preview {
    let placeholder = Space.placeholder
    if let coordinate = placeholder.coordinate {
        SpaceDetailMiniMapView(spaceCoordinates: coordinate)
    }
}
