//
//  Challenge.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

import Foundation

struct Challenge: Identifiable, Codable {
    var id: String = UUID().uuidString 
    var title: String
    var description: String?
    var image: String?
    var target: Double
    var level: ChallengeLevel
    var points: Int
    var date: Date
    var createdAt: Date = Date()

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "description": description ?? "",
            "image": image ?? "",
            "target": target,
            "level": level.rawValue,
            "points": points,
            "date": date.timeIntervalSince1970,
            "createdAt": createdAt.timeIntervalSince1970
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> Challenge? {
        guard let id = dict["id"] as? String,
              let title = dict["title"] as? String,
              let target = dict["target"] as? Double,
              let levelRaw = dict["level"] as? String,
              let level = ChallengeLevel(rawValue: levelRaw),
              let points = dict["points"] as? Int,
              let dateTimestamp = dict["date"] as? TimeInterval,
              let createdAtTimestamp = dict["createdAt"] as? TimeInterval
        else { return nil }

        return Challenge(
            id: id,
            title: title,
            description: dict["description"] as? String,
            image: dict["image"] as? String,
            target: target,
            level: level,
            points: points,
            date: Date(timeIntervalSince1970: dateTimestamp),
            createdAt: Date(timeIntervalSince1970: createdAtTimestamp)
        )
    }
}

enum ChallengeLevel: String, Codable {
    case easy, medium, hard
}
