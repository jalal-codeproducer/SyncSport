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
    @Published var isLoggedIn = false
    @Published var user: SportUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let useCase: AuthUseCase

    init(useCase: AuthUseCase) {
        self.useCase = useCase
        checkAuthState()
    }

    func login(email: String, password: String) async -> Bool {
        isLoading = true
        var isSuccess = false

        defer {
            isLoading = false
        }

        if validateInputs(email: email, password: password) {
            do {
                self.user = try await useCase.login(
                    email: email, password: password)

                isSuccess = true

            } catch {
                errorMessage = error.localizedDescription
            }
        }

        return isSuccess
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
            self.user = try await useCase.register(
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
            self.user = try await useCase.loginAnonyomously()
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        do {
            try useCase.logout()
            self.user = nil
        } catch {
            print("Logout error:", error)
        }
    }

    func checkAuthState() {
        let user = useCase.getCurrentUser()
        if user != nil {
            self.user = user
            isLoggedIn = true
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
