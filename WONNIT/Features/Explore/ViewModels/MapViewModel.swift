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
    var errorMessage: String?
    
    init(locationService: LocationService = .init()) {
        self.locationService = locationService
        self.spaces = []
        self.mapCameraPosition = .region(
            MKCoordinateRegion(
                center: .defaultCoordinate,
                latitudinalMeters: 2000,
                longitudinalMeters: 2000
            )
        )
        
        Task {
            await fetchNearbySpaces(coordinate: .defaultCoordinate)
        }
    }
    
    func fetchNearbySpaces(coordinate: CLLocationCoordinate2D) async {
        do {
            errorMessage = nil
            let client = try await WONNITClientAPIService.shared.client()
            let response = try await client.getNearBySpaces(query: .init(
                lat: coordinate.latitude,
                lon: coordinate.longitude
            ))
            
            let nearbySpaces = try response.ok.body.json
            
            await MainActor.run {
                self.spaces = nearbySpaces.map { Space(from: $0) }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func focusOnUserLocation() {
        guard let userCoordinate = locationService.currentLocation else { return }
        mapCameraPosition = .region(
            MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        )
        
        Task {
            await fetchNearbySpaces(coordinate: userCoordinate)
        }
    }
    
    func panToSelectedSpace() {
        guard let coordinate = selectedSpace?.coordinate else { return }
        
        withAnimation(.spring(duration: 0.8, bounce: 0.3)) {
            self.mapCameraPosition = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
        }
    }
}

extension CLLocationCoordinate2D {
    static let defaultCoordinate: Self = .init(latitude: 37.62990, longitude: 127.07972)
}
