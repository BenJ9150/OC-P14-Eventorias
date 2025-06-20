//
//  FirebaseAuthExtensions.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import Foundation
import FirebaseAuth

extension FirebaseAuth.User: AuthUser {

    var avatarURL: URL? {
        self.photoURL == URL.empty ? nil : self.photoURL
    }

    func createUserProfileChangeRequest() -> AuthUserProfile {
        self.createProfileChangeRequest()
    }
}

extension FirebaseAuth.UserProfileChangeRequest: AuthUserProfile {}
