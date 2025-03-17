//
//  AuthUseCase.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//

protocol AuthUseCase {
    func login(email: String, password: String) async throws -> SportUser
    func register(email: String, password: String, name: String) async throws -> SportUser
    func logout() throws
    func getCurrentUser() -> SportUser?
}

class AuthUseCaseImpl: AuthUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func login(email: String, password: String) async throws -> SportUser {
        return try await repository.login(email: email, password: password)
    }

    func register(email: String, password: String, name: String) async throws -> SportUser {
        return try await repository.register(email: email, password: password, name: name)
    }

    func logout() throws {
        try repository.logout()
    }

    func getCurrentUser() -> SportUser? {
        return repository.getCurrentUser()
    }
}
