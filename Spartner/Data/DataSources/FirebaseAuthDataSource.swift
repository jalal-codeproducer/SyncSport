//
//  FirebaseAuthDataSource.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 17.03.25.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class FirebaseAuthDataSource {
    private let auth = Auth.auth()

    func login(email: String, password: String) async throws -> SportUser {
        let result = try await auth.signIn(withEmail: email, password: password)
        return SportUser(id: result.user.uid, name: result.user.displayName ?? "", email: result.user.email ?? "", points: 0)
    }

    func register(email: String, password: String, name: String) async throws -> SportUser {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = result.user
        let newUser = SportUser(id: user.uid, name: name, email: user.email ?? "", points: 0)
        try await Firestore.firestore().collection("users").document(user.uid).setData(newUser.toDictionary())
        return newUser
    }

    func logout() throws {
        try auth.signOut()
    }

    func getCurrentUser() -> SportUser? {
        guard let user = auth.currentUser else { return nil }
        return SportUser(id: user.uid, name: user.displayName ?? "", email: user.email ?? "", points: 0)
    }
}
