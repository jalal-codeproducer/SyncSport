//
//  LocationManager.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var totalDistanceMoved: Double = 0.0
    
    private var manager = CLLocationManager()
    private var locationHistory: [CLLocation] = []
    
    
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 10
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("Location restricted")
            
        case .denied:
            print("Location denied")
            
        case .authorizedAlways:
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Location service disabled")
        
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        print("\(newLocation.coordinate.latitude)")
        
        if let lastLocation = locationHistory.last {
            let distance = lastLocation.distance(from: newLocation)
            totalDistanceMoved += distance
        }
        
        locationHistory.append(newLocation)
        lastKnownLocation = newLocation.coordinate
    }
}
