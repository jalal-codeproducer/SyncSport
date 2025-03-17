//
//  User.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

import Foundation

struct SportUser: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var points: Int
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "email": email,
            "points": points,
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> SportUser? {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let email = dict["email"] as? String,
              let points = dict["points"] as? Int
        else { return nil }
        
        return SportUser(
            id: id,
            name: name,
            email: email,
            points: points
        )
    }
}
