//
//  SportUserUseCase.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//

protocol UserUseCase {
    func getUser(byId id: String) async throws -> SportUser
    func updateUser(_ user: SportUser) async throws
    func addPointsToUser(userId: String, points: Int) async throws
}

class UserUseCaseImpl: UserUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func getUser(byId id: String) async throws -> SportUser {
        return try await repository.getUser(byId: id)
    }

    func updateUser(_ user: SportUser) async throws {
        try await repository.updateUser(user)
    }

    func addPointsToUser(userId: String, points: Int) async throws {
        try await repository.updateUserPoints(userId: userId, points: points)
    }
}
