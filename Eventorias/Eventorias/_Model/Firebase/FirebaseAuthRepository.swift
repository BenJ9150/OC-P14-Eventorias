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
            if internalErrorContains("PASSWORD_DOES_NOT_MEET_REQUIREMENTS", nsError: nsError) {
                throw AuthErrorCode.weakPassword
            }
            throw nsError
        }
    }

    func updateUser(displayName: String, photoURL: URL?) async throws -> AuthUser {
        guard let user = Auth.auth().currentUser else {
            throw AuthErrorCode.userNotFound
        }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName

        /// Set "blanck URL" to clean old photo URL
        /// (unfortunatly, just set value to nil doesn't erase old value...)
        changeRequest.photoURL = photoURL == nil ? URL.empty : photoURL

        /// Commit change to repo
        try await changeRequest.commitChanges()

        /// Return new data
        guard let userUpdated = Auth.auth().currentUser else {
            throw AuthErrorCode.userNotFound
        }
        return userUpdated
    }

    func sendEmailVerification(beforeUpdatingEmail email: String) async throws {
        do {
            try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
        } catch let nsError as NSError {
            if internalErrorContains("INVALID_NEW_EMAIL", nsError: nsError) {
                throw AuthErrorCode.invalidEmail
            }
            throw nsError
        }
    }

    func reloadUser() async throws {
        try await Auth.auth().currentUser?.reload()
    }
}

// MARK: Firebase internal error

extension FirebaseAuthRepository {

    private func internalErrorContains(_ key: String, nsError: NSError) -> Bool {
        guard nsError.code == 17999 else {
            /// Not a Firebase internal error
            return false
        }
        /// Firebase error 17999: "An internal error has occurred, print and inspect the error details for more information."
        /// Try to find the given key in the internal error:

        let firebaseAuthErrorKey = "FIRAuthErrorUserInfoDeserializedResponseKey"
        if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError,
           let firebaseAuthError = underlyingError.userInfo[firebaseAuthErrorKey] as? [String: Any],
           let message = firebaseAuthError["message"] as? String {
            return message.contains(key)
        }
        return false
    }
}
