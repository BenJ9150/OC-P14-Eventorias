//
//  FirebaseAuthExtensions.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import Foundation
import FirebaseAuth

extension FirebaseAuth.User: AuthUser {
    func createUserProfileChangeRequest() -> AuthUserProfile {
        self.createProfileChangeRequest()
    }
}

extension FirebaseAuth.UserProfileChangeRequest: AuthUserProfile {}
