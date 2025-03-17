//
//  FirestoreUserDataSource.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//

import FirebaseFirestore
import FirebaseFirestore

class FirestoreUserDataSource {
    private let db = Firestore.firestore()

    func fetchUser(byId id: String) async throws -> SportUser {
        let document = try await db.collection("users").document(id).getDocument()
        guard let data = document.data() else {
            throw NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        return try Firestore.Decoder().decode(SportUser.self, from: data)
    }

    func updateUser(_ user: SportUser) async throws {
        try await db.collection("users").document(user.id).setData(user.toDictionary(), merge: true)
    }

    func updateUserPoints(userId: String, points: Int) async throws {
        let userRef = db.collection("users").document(userId)
        try await userRef.updateData(["points": FieldValue.increment(Int64(points))])
    }
}
