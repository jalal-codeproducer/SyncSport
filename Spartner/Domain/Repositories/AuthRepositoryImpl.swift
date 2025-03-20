//
//  Implementation.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

protocol AuthRepository {
    func login(email: String, password: String) async throws
    func register(email: String, password: String, name: String) async throws
    func loginAnonymously() async throws
    func logout() throws
    func getCurrentUser() -> SportUser?
}

class AuthRepositoryImpl: AuthRepository {
    @AppStorage("userId") var userId: String = ""
    private let auth = Auth.auth()

    func login(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        userId = result.user.uid
    }

    func register(email: String, password: String, name: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = result.user
        userId = user.uid
        let newUser = SportUser(
            id: user.uid, name: name, email: user.email ?? "", points: 0)
        try await Firestore.firestore().collection("users").document(user.uid)
            .setData(newUser.toDictionary())
    }

    func loginAnonymously() async throws {
        try await auth.signInAnonymously()
    }

    func logout() throws {
        try auth.signOut()
        userId = ""
    }

    func getCurrentUser() -> SportUser? {
        guard let user = auth.currentUser else { return nil }
        userId = user.uid
        return SportUser(
            id: user.uid, name: user.displayName ?? "", email: user.email ?? "",
            points: 0)
    }
}
