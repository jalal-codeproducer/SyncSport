//
//  RunTrackerViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 09.03.25.
//

import CoreLocation
import Foundation
import Combine

@MainActor
final class TrackViewModel: ObservableObject {
    @Published var trackingStatus: TrackingStatus = .initial
    @Published var totalDistanceMoved: Double = 0.0
    @Published var completedPercentage: Double = 0.0
    @Published var isGoalReached: Bool = false
    @Published var presentCountDown = false
    @Published var speed: Double = 0.0

    @Published var elapsedTimeMinutes: Int = 0
    @Published var elapsedTimeSeconds: Int = 0

    private var cancellables = Set<AnyCancellable>()
    private let trackManager: TrackManager
    private var challenge: Challenge?
    private var timer: Timer?
    private var startTime: Date?

    init(trackManager: TrackManager) {
        self.trackManager = trackManager
        
        trackManager.$totalDistanceMoved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newDistance in
                guard let self = self else { return }
                self.totalDistanceMoved = newDistance
                
                if let challenge = self.challenge {
                    self.completedPercentage = (newDistance / (challenge.target * 1000))
                    
                    if newDistance >= (challenge.target * 1000) {
                        self.stopLocationUpdates()
                    }
                }
                self.updateSpeed()
            }
            .store(in: &cancellables)
    }

    func setChallenge(challenge: Challenge) {
        self.challenge = challenge
    }
    
    func activateCountDown() {
        presentCountDown = true
    }

    func startLocationUpdates() {
        presentCountDown = false
        trackManager.startTrackingUserLocation()
        trackingStatus = .running
        startTimer()
    }

    func stopLocationUpdates() {
        trackManager.stopTrackingUserLocation()
        trackingStatus = .done
        isGoalReached = totalDistanceMoved >= (challenge!.target * 1000)
        stopTimer()
    }

    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, let startTime = self.startTime else { return }
                let elapsedTime = Date().timeIntervalSince(startTime)
                self.updateElapsedTime(elapsedTime)
                self.updateSpeed()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateElapsedTime(_ elapsedTime: TimeInterval) {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        
        self.elapsedTimeMinutes = minutes
        self.elapsedTimeSeconds = seconds
    }

    private func updateSpeed() {
        if let startTime = startTime, Date().timeIntervalSince(startTime) > 0 {
            let elapsedTime = Date().timeIntervalSince(startTime)
            let speedInMetersPerSecond = totalDistanceMoved / elapsedTime
            speed = speedInMetersPerSecond * 3.6
        } else {
            speed = 0.0
        }
    }
    
    func reset() {
        trackingStatus = .initial
        totalDistanceMoved = 0.0
        completedPercentage = 0.0
        isGoalReached = false
        presentCountDown = false
        speed = 0.0
        elapsedTimeMinutes = 0
        elapsedTimeSeconds = 0
        
        challenge = nil
    }
}

enum TrackingStatus {
    case initial, running, done
}
