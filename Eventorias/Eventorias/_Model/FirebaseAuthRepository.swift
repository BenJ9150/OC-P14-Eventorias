//
//  FirebaseAuthRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation
import FirebaseAuth

class FirebaseAuthRepository: AuthRepository {

    var currentUser: AuthUser? {
        Auth.auth().currentUser
    }

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        try await Auth.auth().signIn(withEmail: email, password: password).user
    }

    func sendPasswordReset(withEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
