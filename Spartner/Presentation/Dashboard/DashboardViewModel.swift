//
//  DashboardViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 20.03.25.
//

import Combine
import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    private let repository: ChallengeRepositoryImpl

    @Published var challenges: [Challenge] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(repository: ChallengeRepositoryImpl) {
        self.repository = repository
    }

    func createChallenges() {
        Task {
            do {
                try await repository.createChallenges()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func fetchChallenges() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedChallenges = try await repository.getChallenges()
                DispatchQueue.main.async {
                    self.challenges = fetchedChallenges
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
