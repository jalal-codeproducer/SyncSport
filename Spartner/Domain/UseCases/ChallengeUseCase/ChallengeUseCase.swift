//
//  ChallengeUseCase.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//

protocol ChallengeUseCase {
    func fetchChallenges() async throws -> [Challenge]
    func completeChallenge(_ challenge: Challenge) async throws
}


class ChallengeUseCaseImpl: ChallengeUseCase {
    private let repository: ChallengeRepository

    init(repository: ChallengeRepository) {
        self.repository = repository
    }

    func fetchChallenges() async throws -> [Challenge] {
        return try await repository.getChallenges()
    }

    func completeChallenge(_ challenge: Challenge) async throws {
        try await repository.updateChallengeStatus(challenge, status: .completed)
    }
}
