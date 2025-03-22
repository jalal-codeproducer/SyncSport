//
//  Track.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 22.03.25.
//

import Foundation
import CoreLocation

struct Track: Identifiable {
    var id: String = UUID().uuidString
    var userId: String
    var challengeId: String
    var distance: Double
    var duration: TimeInterval
    var points: Int
    var date: Date
    var path: [CLLocationCoordinate2D]

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "challengeId": challengeId,
            "distance": distance,
            "duration": duration,
            "points": points,
            "date": date.timeIntervalSince1970,
            "path": path.map { ["latitude": $0.latitude, "longitude": $0.longitude] }
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> Track? {
        guard let id = dict["id"] as? String,
              let userId = dict["userId"] as? String,
              let challengeId = dict["challengeId"] as? String,
              let distance = dict["distance"] as? Double,
              let duration = dict["duration"] as? TimeInterval,
              let points = dict["points"] as? Int,
              let dateTimestamp = dict["date"] as? TimeInterval,
              let pathArray = dict["path"] as? [[String: Double]]
        else { return nil }

        let path = pathArray.compactMap { dict -> CLLocationCoordinate2D? in
            guard let latitude = dict["latitude"], let longitude = dict["longitude"] else { return nil }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

        return Track(
            id: id,
            userId: userId,
            challengeId: challengeId,
            distance: distance,
            duration: duration,
            points: points,
            date: Date(timeIntervalSince1970: dateTimestamp),
            path: path
        )
    }
}
