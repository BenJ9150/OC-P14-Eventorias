//
//  FirebaseExtensions.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: FirebaseAuth

extension FirebaseAuth.User: AuthUser {
    func createUserProfileChangeRequest() -> AuthUserProfile {
        self.createProfileChangeRequest()
    }
}

extension FirebaseAuth.UserProfileChangeRequest: AuthUserProfile {}

// MARK: FirebaseFirestore

extension QueryDocumentSnapshot: DocumentRepository {
    func decodedData<T: Decodable>() throws -> T {
        try data(as: T.self)
    }
}
