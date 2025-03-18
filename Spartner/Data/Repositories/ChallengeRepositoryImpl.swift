//
//  Implementation.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

protocol ChallengeRepository {
    func createChallenges() async throws
    func getChallenges() async throws -> [Challenge]
    func updateChallengeStatus(_ challenge: Challenge, status: ChallengeStatus)
        async throws
}

class ChallengeRepositoryImpl: ChallengeRepository {
    private let dataSource: FirestoreChallengeDataSource

    init(dataSource: FirestoreChallengeDataSource) {
        self.dataSource = dataSource
    }

    func createChallenges() async throws {
        try await dataSource.createChallenges()
    }

    func getChallenges() async throws -> [Challenge] {
        return try await dataSource.fetchChallenges()
    }

    func updateChallengeStatus(_ challenge: Challenge, status: ChallengeStatus)
        async throws
    {
        try await dataSource.updateChallengeStatus(challenge, status: status)
    }
}
