//
//  MockAuthUserProfile.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import Foundation
@testable import Eventorias

class MockAuthUserProfile: AuthUserProfile {

    // MARK: Init

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
