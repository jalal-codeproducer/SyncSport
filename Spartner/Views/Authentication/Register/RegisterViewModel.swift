//
//  RegisterViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 05.03.25.
//

import SwiftUI

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var displayname = ""
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    private func validate() -> Bool {
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

    func register() async -> Bool {
        guard validate() else { return false }

        isLoading.toggle()
        do {
            let user = try await authManager.registerWithEmailAndPassword(
                displayName: displayname,
                email: email, password: password)
            isLoading.toggle()
            errorMessage = nil
            return true

        } catch {
            isLoading.toggle()
            errorMessage = error.localizedDescription
            return false
        }
    }

    func singInAnonymously() async -> Bool {
        isLoading.toggle()
        do {
            let user = try await authManager.signInAnonymously()
            isLoading.toggle()
            errorMessage = nil
            return true
        } catch {
            isLoading.toggle()
            errorMessage = error.localizedDescription
            return false
        }
    }
}
