//
//  UserViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//


import Foundation
import Combine

@MainActor
class UserViewModel: ObservableObject {
    private let useCase: UserUseCase
    private var cancellables = Set<AnyCancellable>()

    @Published var user: SportUser?
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(useCase: UserUseCase) {
        self.useCase = useCase
    }

    func fetchUser(userId: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedUser = try await useCase.getUser(byId: userId)
                DispatchQueue.main.async {
                    self.user = fetchedUser
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

    func updateUser(name: String, email: String) {
        guard var currentUser = user else { return }
        currentUser.name = name
        currentUser.email = email

        Task {
            do {
                try await useCase.updateUser(currentUser)
                DispatchQueue.main.async {
                    self.user = currentUser
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func addPoints(points: Int) {
        guard let userId = user?.id else { return }

        Task {
            do {
                try await useCase.addPointsToUser(userId: userId, points: points)
                DispatchQueue.main.async {
                    self.user?.points += points
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
