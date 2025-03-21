//
//  AuthViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 18.03.25.
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var showSplash = true
    @Published var sportUser : SportUser?
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let repository: AuthRepositoryImpl

    init(repository: AuthRepositoryImpl) {
        self.repository = repository
        Task {
            await checkAuthState()
        }
    }

    func login(email: String, password: String) async {
        isLoading = true

        defer {
            isLoading = false
        }

        if validateInputs(email: email, password: password) {
            do {
                try await repository.login(
                    email: email, password: password)

                isLoggedIn = true

            } catch {
                errorMessage = error.localizedDescription
            }
        }

    }

    func register(
        email: String, password: String, repeatPassword: String, name: String
    ) async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            guard
                validate(
                    email: email, password: password,
                    repeatPassword: repeatPassword)
            else {
                return
            }
            try await repository.register(
                email: email, password: password, name: name)
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loginAnonymously() async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            try await repository.loginAnonymously()
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        do {
            try repository.logout()
            isLoggedIn = false
        } catch {
            print("Logout error:", error)
        }
    }

    func checkAuthState() async {
        try? await Task.sleep(nanoseconds: 2_500_000_000)
        defer {
            showSplash = false
        }
        do{
            let user = try await repository.getCurrentUser()
            if user != nil {
                sportUser = user
                isLoggedIn = true
            }
        } catch {
            print(error.localizedDescription)
        }

    }

    private func validate(
        email: String, password: String, repeatPassword: String
    ) -> Bool {
        if email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
            errorMessage = "All fields are required."
            return false
        }
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Invalid email format."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        if password != repeatPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        return true
    }

    private func validateInputs(email: String, password: String) -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and password cannot be empty"
            return false
        }

        if !isValidEmail(email) {
            errorMessage = "Invalid email format"
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(
            with: email)
    }
}
