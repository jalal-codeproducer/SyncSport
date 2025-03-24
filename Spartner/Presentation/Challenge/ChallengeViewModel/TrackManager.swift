import Combine
import CoreLocation

final class TrackManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var totalDistanceMoved: Double = 0.0
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var trackingPath: [CLLocationCoordinate2D] = []
    
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
        manager.allowsBackgroundLocationUpdates = true
        manager.startUpdatingLocation()
    }
    
    func stopTrackingUserLocation() {
        manager.stopUpdatingLocation()
    }
    
    func resetTrackingData() {
        totalDistanceMoved = 0.0
        lastKnownLocation = nil
        trackingPath.removeAll()
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
        trackingPath.append(newLocation.coordinate)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        startTrackingUserLocation()
    }
}
