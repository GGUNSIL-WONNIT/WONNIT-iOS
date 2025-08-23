//
//  MapViewModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import Foundation
import SwiftUI
import MapKit

@Observable
final class MapViewModel {
    let locationService: LocationService
    
    var spaces: [Space]
    var selection: String?
    var selectedSpace: Space? {
        spaces.first { $0.id == selection }
    }
    var mapCameraPosition: MapCameraPosition
    
    init(locationService: LocationService = .init()) {
        self.locationService = locationService
        
        self.spaces = Space.mockList
        
        self.mapCameraPosition = .region(
            MKCoordinateRegion(
                center: .defaultCoordinate,
                latitudinalMeters: 2000,
                longitudinalMeters: 2000
            )
        )
    }
    
    
    // MARK: Actions
    func focusOnUserLocation() {
        guard let userCoordinate = locationService.currentLocation else { return }
        mapCameraPosition = .region(
            MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        )
    }
    
    func panToSelectedSpace() {
        guard let coordinate = selectedSpace?.coordinate else { return }
        
        withAnimation(.spring(duration: 0.8, bounce: 0.3)) {
            self.mapCameraPosition = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
        }
    }

//    func deselectSpace() {
//        selectedSpace = nil
//    }
}

extension CLLocationCoordinate2D {
    static let defaultCoordinate: Self = .init(latitude: 37.62990, longitude: 127.07972)
}
