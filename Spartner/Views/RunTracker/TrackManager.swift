//
//  LocationManager.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import Combine
import CoreLocation

final class TrackManager: NSObject, ObservableObject, CLLocationManagerDelegate
{

    private let manager = CLLocationManager()

    @Published var totalDistanceMoved: Double = 0.0
    @Published var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func startTrackingUserLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            return

        case .authorizedAlways, .authorizedWhenInUse:
            beginLocationUpdates()

        @unknown default:
            return
        }
    }

    private func beginLocationUpdates() {
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 10
        manager.pausesLocationUpdatesAutomatically = false
        manager.startUpdatingLocation()
    }

    func stopTrackingUserLocation() {
        manager.stopUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        guard let newLocation = locations.last else { return }

        if let lastLocation = lastKnownLocation {
            let lastCLLocation = CLLocation(
                latitude: lastLocation.latitude,
                longitude: lastLocation.longitude)
            let distanceMoved = newLocation.distance(from: lastCLLocation)
            totalDistanceMoved += distanceMoved
        }

        lastKnownLocation = newLocation.coordinate
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        startTrackingUserLocation()
    }
}
