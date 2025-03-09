//
//  RunTrackerViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import Foundation
import CoreLocation

@MainActor
final class RunTrackerViewModel: ObservableObject {
    @Published var totalDistanceMoved: Double = 0.0
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var isRunning = false
    @Published var presentCountDown = false
    
    private let trackManger: TrackManager

    init(trackManger: TrackManager) {
        self.trackManger = trackManger
        
        trackManger.$totalDistanceMoved
            .assign(to: &$totalDistanceMoved)

        trackManger.$lastKnownLocation
            .assign(to: &$lastKnownLocation)
    }
    

    func startLocationUpdates() {
        presentCountDown.toggle()
        isRunning = true
        trackManger.startTrackingUserLocation()
    }

    func stopLocationUpdates() {
        isRunning = false
        trackManger.stopTrackingUserLocation()
    }
}
