//
//  HomeViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import SwiftUI
import CoreLocation

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var totalDistanceMoved: Double = 0.0
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    private let locationManager: LocationManager

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        
        locationManager.$totalDistanceMoved
            .assign(to: &$totalDistanceMoved)

        locationManager.$lastKnownLocation
            .assign(to: &$lastKnownLocation)
    }
    

    func startLocationUpdates() {
        locationManager.checkLocationAuthorization()
    }
}
