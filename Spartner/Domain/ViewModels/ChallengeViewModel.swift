//
//  ChallengeViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//


import Foundation
import Combine

@MainActor
class ChallengeViewModel: ObservableObject {
    private let useCase: ChallengeUseCase
    private var cancellables = Set<AnyCancellable>()

    @Published var challenges: [Challenge] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(useCase: ChallengeUseCase) {
        self.useCase = useCase
    }

    func fetchChallenges() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedChallenges = try await useCase.fetchChallenges()
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
                if let challenge = challenges.first(where: { $0.id == challengeId }) {
                    try await useCase.completeChallenge(challenge)

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
