//
//  AuthService.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation

class AuthService {

    let authRepo: AuthRepository

    init(authRepo: AuthRepository = FirebaseAuthRepository()) {
        self.authRepo = authRepo
    }

    func updateUser(displayName: String, photoURL: String) async throws {
        guard let currentUser = authRepo.currentUser else {
            throw AppError.currentUserNotFound
        }
        guard !displayName.isEmpty || !photoURL.isEmpty else {
            return
        }
        var changeRequest = currentUser.createUserProfileChangeRequest()

        /// Update display name
        if !displayName.isEmpty {
            changeRequest.displayName = displayName
        }
        /// Update photo URL
        if let url = URL(string: photoURL) {
            changeRequest.photoURL = url
        }
        /// Try to commit changes
        try await changeRequest.commitChanges()
    }
}
