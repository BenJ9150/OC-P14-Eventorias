//
//  MockAuthUser.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import Foundation
@testable import Eventorias

class MockUser: AuthUser {

    init(email: String? = nil, displayName: String? = nil, photoURL: URL? = nil) {
        self.email = email
        self.displayName = displayName
        self.avatarURL = photoURL
    }

    // MARK: AuthUser protocol

    let uid = UUID().uuidString
    var email: String?
    var displayName: String?
    var avatarURL: URL?

    func createUserProfileChangeRequest() -> AuthUserProfile {
        MockAuthUserProfile(user: self)
    }
}

class MockAuthUserProfile: AuthUserProfile {

    private let user: MockUser
    init(user: MockUser) {
        self.user = user
    }

    // MARK: AuthUserProfile Protocol

    var displayName: String?
    var photoURL: URL?

    func commitChanges() async throws {
        user.displayName = displayName
        user.avatarURL = photoURL
    }
}
