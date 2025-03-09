//
//  AuthManager.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 05.03.25.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore

enum AuthState {
    case authenticated
    case signedIn
    case signedOut
}

class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var authState = AuthState.signedOut

    private var authStateHandle: AuthStateDidChangeListenerHandle!

    init() {
        configureAuthStateChanges()
    }

    func configureAuthStateChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
            self.updateState(user: user)
        }
    }

    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }

    func updateState(user: User?) {
        self.user = user
        let isAuthenticatedUser = user != nil
        let isAnonymous = user?.isAnonymous ?? false

        if isAuthenticatedUser {
            self.authState = isAnonymous ? .authenticated : .signedIn
        } else {
            self.authState = .signedOut
        }
    }

    func signInAnonymously() async throws -> User? {
        do {
            let result = try await Auth.auth().signInAnonymously()
            return result.user
        } catch {
            throw error
        }
    }

    func registerWithEmailAndPassword(
        displayName: String, email: String, password: String
    )
        async throws -> User?
    {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email, password: password)
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
            return result.user
        } catch {
            throw error
        }
    }

    func signInWithEmailAndPassword(email: String, password: String)
        async throws -> User?
    {
        do {
            let result = try await Auth.auth().signIn(
                withEmail: email, password: password)
            return result.user
        } catch {
            throw error
        }
    }
}
