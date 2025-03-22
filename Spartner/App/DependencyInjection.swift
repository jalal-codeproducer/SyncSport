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

    private init() {}  // Prevent direct instantiation

    // MARK: - Repositories (Singleton Instances)
    private lazy var sportUserRepository: SportUserRepository =
        SportUserRepositoryImpl()
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    private lazy var challengeRepository: ChallengeRepository =
        ChallengeRepositoryImpl()

    // MARK: - View Models (Singleton Instances)
    private var authViewModel: AuthViewModel?
    private var dashboardViewModel: DashboardViewModel?
    private var runTrackerViewModel: TrackViewModel?

    // MARK: - View Model Providers
    @MainActor
    func provideAuthViewModel() -> AuthViewModel {
        if let authViewModel = authViewModel {
            return authViewModel
        }
        let newAuthViewModel = AuthViewModel(
            repository: authRepository as! AuthRepositoryImpl)
        authViewModel = newAuthViewModel
        return newAuthViewModel
    }


    @MainActor
    func provideDashboardViewModel() -> DashboardViewModel {
        if let dashboardViewModel = dashboardViewModel {
            return dashboardViewModel
        }
        let newDashboardViewModel = DashboardViewModel(
            repository: challengeRepository as! ChallengeRepositoryImpl)
        dashboardViewModel = newDashboardViewModel
        return newDashboardViewModel
    }
    
    @MainActor
    func provideRunTrackerViewmodel() -> TrackViewModel {
        if let runTrackerViewModel = runTrackerViewModel {
            return runTrackerViewModel
        }
        let newRunTrackerViewModel = TrackViewModel(
            trackManager: TrackManager())
        runTrackerViewModel = newRunTrackerViewModel
        return newRunTrackerViewModel
    }
}
