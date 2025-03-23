//
//  Implementation.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

import FirebaseFirestore
import CoreLocation

protocol ChallengeRepository {
    func createChallenges() async throws
    func getChallenges() async throws -> [Challenge]
    func trackChallenge(track: Track) async throws
    func fetchChallengeTracks(userId: String) async throws -> [Track]
}

class ChallengeRepositoryImpl: ChallengeRepository {
    private let db = Firestore.firestore()

    func createChallenges() async throws {
        let imageNames = (1...10).map { "\($0)" }
        var base64Images: [String] = []

        for imageName in imageNames {
            if let image = UIImage(named: imageName),
               let base64String = ImageUtilities.imageToBase64String(image)
            {
                base64Images.append(base64String)
            } else {
                base64Images.append("")
            }
        }

        let challenges: [Challenge] = [
            Challenge(
                title: "Quick Start: 1K Warm-Up",
                description:
                    "Begin your fitness journey with a light 1km jog or brisk walk. Perfect for warming up the body and getting into a routine.",
                image: base64Images[9],
                target: 1.0,
                level: .easy,
                points: 50,
                date: Date()
            ),
            Challenge(
                title: "Evening 3K Walk",
                description:
                    "Complete a steady 3km walk in the evening. A great way to relax, improve stamina, and stay consistent.",
                image: base64Images[0],
                target: 3.0,
                level: .easy,
                points: 100,
                date: Date()
            ),
            Challenge(
                title: "5K Endurance Run",
                description:
                    "Build endurance by running a continuous 5km. Maintain a comfortable pace and track your progress over time.",
                image: base64Images[1],
                target: 5.0,
                level: .medium,
                points: 200,
                date: Date()),
            Challenge(
                title: "7K Steady Challenge",
                description:
                    "Push your limits with a controlled 7km run. Focus on steady breathing and pacing.",
                image: base64Images[8],
                target: 7.0,
                level: .medium,
                points: 300,
                date: Date()
            ),
            Challenge(
                title: "10K Consistency Goal",
                description:
                    "Run or walk 10km at your own pace. A great challenge for improving endurance and fitness.",
                image: base64Images[2],
                target: 10.0,
                level: .hard,
                points: 500,
                date: Date()
            ),
            Challenge(
                title: "15K Long Run",
                description:
                    "Commit to a long 15km run. Ideal for building stamina and testing your endurance.",
                image: base64Images[3],
                target: 15.0,
                level: .hard,
                points: 750,
                date: Date()
            ),
            Challenge(
                title: "2K Speed Test",
                description:
                    "Complete a 2km run with a focus on speed. Try to push your pace while maintaining good form.",
                image: base64Images[4],
                target: 2.0,
                level: .easy,
                points: 80,
                date: Date()
            ),
            Challenge(
                title: "Weekly 25K Goal",
                description:
                    "Accumulate a total of 25km over a week. Whether you walk or run, stay consistent and track your progress.",
                image: base64Images[5],
                target: 25.0,
                level: .hard,
                points: 900,
                date: Date()
            ),
            Challenge(
                title: "12K Training Session",
                description:
                    "Complete a structured 12km run. Focus on pacing and hydration to keep energy levels up.",
                image: base64Images[6],
                target: 12.0,
                level: .hard,
                points: 600,
                date: Date()
            ),
            Challenge(
                title: "30-Day Daily Run",
                description:
                    "Run at least 1km daily for 30 days. Build consistency and develop a lasting habit.",
                image: base64Images[7],
                target: 30.0,
                level: .hard,
                points: 1200,
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

    func getChallenges() async throws -> [Challenge] {
        let snapshot = try await db.collection("challenges").getDocuments()
        return snapshot.documents.compactMap {
            Challenge.fromDictionary($0.data())
        }
    }

    func trackChallenge(track: Track) async throws {
        let collectionRef = db.collection("tracks")
        let documentRef = collectionRef.document(track.id)
        let trackData = track.toDictionary()

        try await documentRef.setData(trackData)
    }

    func fetchChallengeTracks(userId: String) async throws -> [Track] {
        let snapshot = try await db.collection("tracks")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()

        return snapshot.documents.compactMap {
            Track.fromDictionary($0.data())
        }
    }
}
