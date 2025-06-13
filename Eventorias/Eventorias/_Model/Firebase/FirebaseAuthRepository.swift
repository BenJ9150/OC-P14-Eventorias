//
//  FirebaseAuthRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import Foundation
import FirebaseAuth

class FirebaseAuthRepository: AuthRepository {

    var currentUser: AuthUser? {
        Auth.auth().currentUser
    }

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        return try await Auth.auth().signIn(withEmail: email, password: password).user
    }

    func sendPasswordReset(withEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func createUser(withEmail email: String, password: String) async throws -> AuthUser {
        do {
            return try await Auth.auth().createUser(withEmail: email, password: password).user
        } catch let nsError as NSError {
            // Firebase issue for password does not meet requirements:
            // Throw Code=17999 "An internal error has occurred, print and inspect the error details for more information."
            // To fix this issue, try to find "PASSWORD_DOES_NOT_MEET_REQUIREMENTS" in the internal error:
            
            let firebaseAuthErrorKey = "FIRAuthErrorUserInfoDeserializedResponseKey"
            let weakPasswordError = "PASSWORD_DOES_NOT_MEET_REQUIREMENTS"

            if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError,
               let firebaseAuthError = underlyingError.userInfo[firebaseAuthErrorKey] as? [String: Any],
               let message = firebaseAuthError["message"] as? String, message.contains(weakPasswordError) {
                throw AuthErrorCode.weakPassword
            }
            throw nsError
        }
    }

    func updateUser(displayName: String, photoURL: URL?) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthErrorCode.userNotFound
        }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        changeRequest.photoURL = photoURL
        try await changeRequest.commitChanges()
    }

    func updateUserEmail(with email: String) async throws {
        try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
    }

    func reloadUser() async throws {
        try await Auth.auth().currentUser?.reload()
    }
}
