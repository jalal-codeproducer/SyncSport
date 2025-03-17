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
    var target: String
    var level: ChallengeLevel
    var points: Int
    var status: ChallengeStatus
    var date: Date
    var createdAt: Date = Date()

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "description": description ?? "",
            "target": target,
            "level": level.rawValue,
            "points": points,
            "status": status.rawValue,
            "date": date.timeIntervalSince1970,
            "createdAt": createdAt.timeIntervalSince1970
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> Challenge? {
        guard let id = dict["id"] as? String,
              let title = dict["title"] as? String,
              let target = dict["target"] as? String,
              let levelRaw = dict["level"] as? String,
              let level = ChallengeLevel(rawValue: levelRaw),
              let points = dict["points"] as? Int,
              let statusRaw = dict["status"] as? String,
              let status = ChallengeStatus(rawValue: statusRaw),
              let dateTimestamp = dict["date"] as? TimeInterval,
              let createdAtTimestamp = dict["createdAt"] as? TimeInterval
        else { return nil }

        return Challenge(
            id: id,
            title: title,
            description: dict["description"] as? String,
            target: target,
            level: level,
            points: points,
            status: status,
            date: Date(timeIntervalSince1970: dateTimestamp),
            createdAt: Date(timeIntervalSince1970: createdAtTimestamp)
        )
    }
}

enum ChallengeLevel: String, Codable {
    case easy, medium, hard
}

enum ChallengeStatus: String, Codable {
    case notStarted = "not_started"
    case inProgress = "in_progress"
    case completed = "completed"
}
