//
//  LoginViewModel.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 06.03.25.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    func signIn() async -> Bool {
        guard validateInputs() else { return false }

        isLoading = true
        
        do {
            let user = try await authManager.signInWithEmailAndPassword(
                email: email, password: password)
            errorMessage = nil
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
        
    }
    
    private func validateInputs() -> Bool {
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
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
