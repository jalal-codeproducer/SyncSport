//
//  ChallengeViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//

import Combine
import Foundation

@MainActor
class ChallengeViewModel: ObservableObject {
    private let repository: ChallengeRepositoryImpl
    private var cancellables = Set<AnyCancellable>()

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

    func completeChallenge(challengeId: String) {
        Task {
            do {
                if let challenge = challenges.first(where: {
                    $0.id == challengeId
                }) {
                    try await repository.updateChallengeStatus(
                        challenge, status: .completed)

                    DispatchQueue.main.async {
                        self.challenges.removeAll { $0.id == challengeId }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
