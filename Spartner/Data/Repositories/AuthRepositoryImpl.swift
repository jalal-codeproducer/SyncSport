//
//  Implementation.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

protocol AuthRepository {
    func login(email: String, password: String) async throws -> SportUser
    func register(email: String, password: String, name: String) async throws -> SportUser
    func loginAnonyomously() async throws -> SportUser
    func logout() throws
    func getCurrentUser() -> SportUser?
}


class AuthRepositoryImpl: AuthRepository {
    private let dataSource: FirebaseAuthDataSource

    init(dataSource: FirebaseAuthDataSource) {
        self.dataSource = dataSource
    }

    func login(email: String, password: String) async throws -> SportUser {
        return try await dataSource.login(email: email, password: password)
    }

    func register(email: String, password: String, name: String) async throws -> SportUser {
        return try await dataSource.register(email: email, password: password, name: name)
    }
    
    func loginAnonyomously() async throws -> SportUser {
        return try await dataSource.loginAnonyomously()
    }

    func logout() throws {
        try dataSource.logout()
    }

    func getCurrentUser() -> SportUser? {
        return dataSource.getCurrentUser()
    }
}
