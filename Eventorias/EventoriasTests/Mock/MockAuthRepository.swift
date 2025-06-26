//
//  MockAuthRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation
@testable import Eventorias

// MARK: AuthRepository

class MockAuthRepository: AuthRepository {

    var currentUser: AuthUser?
    var user = MockUser(email: "test@test.com", displayName: "NameTest")

    init(isConnected: Bool = true, withAvatar: Bool = true) {
        if withAvatar {
            self.user = MockUser(email: "test@test.com", displayName: "NameTest", photoURL: URL(string: "https://www.test.com")!)
        }
        self.currentUser = isConnected ? user : nil
    }

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        currentUser = MockUser(email: email)
        return currentUser!
    }

    func sendPasswordReset(withEmail email: String) async throws {}

    func signOut() throws {
        currentUser = nil
    }

    func createUser(withEmail email: String, password: String) async throws -> AuthUser {
        currentUser = MockUser(email: email)
        return currentUser!
    }

    func updateUser(displayName: String?, photoURL: URL?) async throws -> AuthUser {
        currentUser = MockUser(email: currentUser?.email, displayName: displayName, photoURL: photoURL)
        return currentUser!
    }

    func sendEmailVerification(beforeUpdatingEmail email: String) async throws {}

    func reloadUser() async throws {}
}

// MARK: AuthUser

class MockUser: AuthUser {

    let uid = UUID().uuidString
    var email: String?
    var displayName: String?
    var avatarURL: URL?

    init(email: String? = nil, displayName: String? = nil, photoURL: URL? = nil) {
        self.email = email
        self.displayName = displayName
        self.avatarURL = photoURL
    }

    func createUserProfileChangeRequest() -> AuthUserProfile {
        class TempProfile: AuthUserProfile {
            var displayName: String?
            var photoURL: URL?
            func commitChanges() async throws {}
        }
        return TempProfile()
    }
}
