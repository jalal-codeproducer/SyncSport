//
//  RunTrackerViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import CoreLocation
import Foundation

@MainActor
final class RunTrackerViewModel: ObservableObject {
    @Published var trackingStatus: TrackingStatus = .initial
    @Published var totalDistanceMoved: Double = 0.0
    @Published var presentCountDown = false

    private let trackManger: TrackManager

    init(trackManger: TrackManager) {
        self.trackManger = trackManger

        trackManger.$totalDistanceMoved
            .assign(to: &$totalDistanceMoved)
    }

    func activateCountDown() {
        presentCountDown = true
    }

    func startLocationUpdates() {
        presentCountDown = false
        trackManger.startTrackingUserLocation()
        trackingStatus = .running
    }

    func stopLocationUpdates() {
        trackManger.stopTrackingUserLocation()
        trackingStatus = .done
    }
}

enum TrackingStatus {
    case
        initial,
        running,
        done
}
