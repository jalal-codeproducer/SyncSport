//
//  SportUserRepositoryImpl.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//

protocol UserRepository {
    func getUser(byId id: String) async throws -> SportUser
    func updateUser(_ user: SportUser) async throws
    func updateUserPoints(userId: String, points: Int) async throws
}

class UserRepositoryImpl: UserRepository {
    private let dataSource: FirestoreUserDataSource

    init(dataSource: FirestoreUserDataSource) {
        self.dataSource = dataSource
    }

    func getUser(byId id: String) async throws -> SportUser {
        return try await dataSource.fetchUser(byId: id)
    }

    func updateUser(_ user: SportUser) async throws {
        try await dataSource.updateUser(user)
    }

    func updateUserPoints(userId: String, points: Int) async throws {
        try await dataSource.updateUserPoints(userId: userId, points: points)
    }
}
