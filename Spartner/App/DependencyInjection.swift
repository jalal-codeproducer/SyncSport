//
//  DependencyInjection.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//


import Foundation

class DependencyInjection {
    
    // MARK: - Singleton Instance
    static let shared = DependencyInjection()

    private init() {} // Prevent direct instantiation

    // MARK: - Data Sources (Singleton Instances)
    private let firestoreUserDataSource = FirestoreUserDataSource()
    private let firebaseAuthDataSource = FirebaseAuthDataSource()
    private let firestoreChallengeDataSource = FirestoreChallengeDataSource()

    // MARK: - Repositories (Singleton Instances)
    private lazy var userRepository: UserRepository = UserRepositoryImpl(dataSource: firestoreUserDataSource)
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl(dataSource: firebaseAuthDataSource)
    private lazy var challengeRepository: ChallengeRepository = ChallengeRepositoryImpl(dataSource: firestoreChallengeDataSource)

    // MARK: - Use Cases (Singleton Instances)
    private lazy var userUseCase: UserUseCase = UserUseCaseImpl(repository: userRepository)
    private lazy var authUseCase: AuthUseCase = AuthUseCaseImpl(repository: authRepository)
    private lazy var challengeUseCase: ChallengeUseCase = ChallengeUseCaseImpl(repository: challengeRepository)

    // MARK: - View Models (Instance Providers)
    @MainActor
    func provideAuthViewModel() -> AuthViewModel {
        return AuthViewModel(useCase: authUseCase)
    }

    @MainActor
    func provideUserViewModel() -> UserViewModel {
        return UserViewModel(useCase: userUseCase)
    }
    
    @MainActor
    func provideChallengeViewModel() -> ChallengeViewModel {
        return ChallengeViewModel(useCase: challengeUseCase)
    }
}
