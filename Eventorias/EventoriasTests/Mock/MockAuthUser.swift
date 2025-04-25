//
//  MockAuthUser.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import Foundation
@testable import Eventorias

class MockUser: AuthUser {

    // MARK: init

    init(email: String? = nil, displayName: String? = nil, photoURL: URL? = nil) {
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
    }

    // MARK: AuthUser protocol

    let uid = UUID().uuidString
    var email: String?
    var displayName: String?
    var photoURL: URL?

    func createUserProfileChangeRequest() -> AuthUserProfile {
        MockAuthUserProfile(user: self)
    }
}
