//
//  FirestoreChallengeDataSource.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

import FirebaseFirestore

class FirestoreChallengeDataSource {
    private let db = Firestore.firestore()

    func fetchChallenges() async throws -> [Challenge] {
        let snapshot = try await db.collection("challenges").getDocuments()
        return snapshot.documents.compactMap { Challenge.fromDictionary($0.data()) }
    }

    func updateChallengeStatus(_ challenge: Challenge, status: ChallengeStatus) async throws {
        try await db.collection("challenges").document(challenge.id).updateData(["status": status.rawValue])
    }
}
