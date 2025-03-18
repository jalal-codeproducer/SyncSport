//
//  FirestoreChallengeDataSource.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

import FirebaseFirestore

class FirestoreChallengeDataSource {
    private let db = Firestore.firestore()

    func createChallenges() async throws {
        let challenges: [Challenge] = [
            Challenge(
                title: "Quick Start: 1K Warm-Up",
                description:
                    "Begin your fitness journey with a light 1km jog or brisk walk. Perfect for warming up the body and getting into a routine.",
                target: 1.0,
                level: .easy,
                points: 50,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "Evening 3K Walk",
                description:
                    "Complete a steady 3km walk in the evening. A great way to relax, improve stamina, and stay consistent.",
                target: 3.0,
                level: .easy,
                points: 100,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "5K Endurance Run",
                description:
                    "Build endurance by running a continuous 5km. Maintain a comfortable pace and track your progress over time.",
                target: 5.0,
                level: .medium,
                points: 200,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "7K Steady Challenge",
                description:
                    "Push your limits with a controlled 7km run. Focus on steady breathing and pacing.",
                target: 7.0,
                level: .medium,
                points: 300,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "10K Consistency Goal",
                description:
                    "Run or walk 10km at your own pace. A great challenge for improving endurance and fitness.",
                target: 10.0,
                level: .hard,
                points: 500,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "15K Long Run",
                description:
                    "Commit to a long 15km run. Ideal for building stamina and testing your endurance.",
                target: 15.0,
                level: .hard,
                points: 750,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "2K Speed Test",
                description:
                    "Complete a 2km run with a focus on speed. Try to push your pace while maintaining good form.",
                target: 2.0,
                level: .easy,
                points: 80,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "Weekly 25K Goal",
                description:
                    "Accumulate a total of 25km over a week. Whether you walk or run, stay consistent and track your progress.",
                target: 25.0,
                level: .hard,
                points: 900,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "12K Training Session",
                description:
                    "Complete a structured 12km run. Focus on pacing and hydration to keep energy levels up.",
                target: 12.0,
                level: .hard,
                points: 600,
                status: .notStarted,
                date: Date()
            ),
            Challenge(
                title: "30-Day Daily Run",
                description:
                    "Run at least 1km daily for 30 days. Build consistency and develop a lasting habit.",
                target: 30.0,
                level: .hard,
                points: 1200,
                status: .notStarted,
                date: Date()
            ),
        ]

        let collectionRef = db.collection("challenges")

        for challenge in challenges {
            let documentRef = collectionRef.document()
            let challengeData = challenge.toDictionary()

            try await documentRef.setData(challengeData)
        }
    }

    func fetchChallenges() async throws -> [Challenge] {
        let snapshot = try await db.collection("challenges").getDocuments()
        return snapshot.documents.compactMap {
            Challenge.fromDictionary($0.data())
        }
    }

    func updateChallengeStatus(_ challenge: Challenge, status: ChallengeStatus)
        async throws
    {
        try await db.collection("challenges").document(challenge.id).updateData(
            ["status": status.rawValue])
    }
}
