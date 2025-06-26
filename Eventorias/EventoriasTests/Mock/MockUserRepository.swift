//
//  MockUserRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 26/06/2025.
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockUserRepository {

    var user = MockUser(email: "test@test.com", displayName: "NameTest")

    private let userWithAvatar = MockUser(email: "test@test.com", displayName: "NameTest", photoURL: URL(string: "https://www.test.com")!)
    private var currentUser: AuthUser?
    private var codeError: Int?
    private var withAvatar: Bool

    // MARK: Init
    
    init(withError codeError: Int? = nil, isConnected: Bool = false, withAvatar: Bool = true) {
        self.codeError = codeError
        self.withAvatar = withAvatar

        if isConnected {
            if withAvatar {
                self.user = userWithAvatar
            }
            self.currentUser = user
        }
    }
}

// MARK: UserRepository protocol

extension MockUserRepository: UserRepository {

    func signUp(email: String, password: String, name: String) async throws -> AuthUser {
        try canPerform()
        let user = MockUser(email: email, displayName: name)
        currentUser = user
        return user
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        try canPerform()
        if withAvatar {
            user = userWithAvatar
        }
        currentUser = user
        return user
    }
    
    func signOut() throws {
        try canPerform()
        currentUser = nil
    }
    
    func sendPasswordReset(withEmail email: String) async throws {
        try canPerform()
    }
    
    func getUser() -> AuthUser? {
        currentUser
    }
    
    func reloadUser() async {}
    
    func udpateUser(name: String, avatar: UIImage?) async throws -> AuthUser {
        try canPerform()
        guard let user = currentUser as? MockUser else {
            throw AppError.currentUserNotFound
        }
        
        let newURL: URL? = try {
            if let image = avatar {
                _ = try image.jpegData(maxSize: 300)
                return URL(string: "https://www.testupdate.com")!
            } else {
                return user.avatarURL
            }
        }()

        currentUser = MockUser(email: user.email, displayName: name, photoURL: newURL)
        return currentUser!
    }
    
    func udpateUser(email: String) async throws -> Bool {
        try canPerform()
        return email != currentUser?.email
    }
    
    func deleteUserPhoto() async throws -> AuthUser {
        try canPerform()
        guard let user = currentUser as? MockUser else {
            throw AppError.currentUserNotFound
        }
        guard user.avatarURL != nil else {
            /// No avatar to delete
            return user
        }
        currentUser = MockUser(email: user.email, displayName: user.displayName, photoURL: nil)
        return currentUser!
    }
}

// MARK: Private

extension MockUserRepository {

    private func canPerform() throws {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
    }
}
