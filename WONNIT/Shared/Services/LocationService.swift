//
//  LocationService.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import Foundation
import CoreLocation

@Observable
final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    
    private(set) var currentLocation: CLLocationCoordinate2D?
    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private(set) var locationError: String?

    override init() {
        super.init()
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // meters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastCoordinate = locations.last?.coordinate else { return }
        currentLocation = lastCoordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationError = "정확한 위치 정보를 위해 설정에서 위치 권한을 허용해 주세요."
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error.localizedDescription
        print("CoreLocation error: \(error.localizedDescription)")
    }
}
