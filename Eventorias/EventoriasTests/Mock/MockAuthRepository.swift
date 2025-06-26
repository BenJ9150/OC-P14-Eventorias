//
//  MockAuthRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation
@testable import Eventorias

class MockAuthRepository: AuthRepository {
    
    private var codeError: Int?

    // MARK: Init
    
    init(withError codeError: Int? = nil, isConnected: Bool = false, withAvatar: Bool = true) {
        self.codeError = codeError
        if isConnected {
            currentUser = MockUser(
                email: "test@test.com",
                displayName: "TestName",
                photoURL: withAvatar ? URL(string: "https://www.test.com") : nil
            )
        }
    }

    // MARK: AuthRepository protocol

    var currentUser: AuthUser?

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        try canPerform()
        let user = MockUser(
            email: email,
            displayName: "TestName",
            photoURL: URL(string: "https://www.test.com")
        )
        currentUser = user
        return user
    }

    func sendPasswordReset(withEmail email: String) async throws {
        try canPerform()
    }

    func signOut() throws {
        try canPerform()
        currentUser = nil
    }

    func createUser(withEmail email: String, password: String) async throws -> AuthUser {
        try canPerform()
        let user = MockUser(email: email)
        currentUser = user
        return user
    }

    func updateUser(displayName: String, photoURL: URL?) async throws -> AuthUser {
        try canPerform()
        currentUser = MockUser(email: currentUser?.email, displayName: displayName, photoURL: photoURL)
        return currentUser!
    }

    func sendEmailVerification(beforeUpdatingEmail email: String) async throws {
        try canPerform()
    }

    func reloadUser() async throws {
        try canPerform()
        guard let user = currentUser as? MockUser else {
            throw AppError.currentUserNotFound
        }
        currentUser = MockUser(
            email: user.email,
            displayName: user.displayName,
            photoURL: user.avatarURL
        )
    }
}

// MARK: Private

extension MockAuthRepository {

    private func canPerform() throws {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
    }
}
