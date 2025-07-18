//
//  PreviewUserRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/06/2025.
//

import Foundation
import SwiftUI

class PreviewUserRepository {

    private var codeError: Int?
    private var currentUser: AuthUser?

    // MARK: Init

    init(withError codeError: Int? = nil, isConnected: Bool = true) {
        self.codeError = codeError
        if isConnected {
            currentUser = PreviewUser()
        }
    }
}

// MARK: UserRepository protocol

extension PreviewUserRepository: UserRepository {
    

    func signUp(email: String, password: String, name: String) async throws -> AuthUser {
        try await canPerform()
        let user = PreviewUser(email: email, name: name, avatarURL: nil)
        currentUser = user
        return user
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        try await canPerform()
        let user = PreviewUser(email: email)
        currentUser = user
        return user
    }
    
    func signOut() throws {
        currentUser = nil
    }
    
    func sendPasswordReset(withEmail email: String) async throws {
        try await canPerform()
    }
    
    func getUser() -> AuthUser? {
        currentUser
    }
    
    func reloadUser() async {
        try? await canPerform()
    }
    
    func udpateUser(name: String, avatar: UIImage?) async throws -> AuthUser {
        try await canPerform()
        currentUser = PreviewUser(email: currentUser?.email, name: name, withAvatar: avatar != nil)
        return currentUser!
    }
    
    func udpateUser(email: String) async throws -> Bool {
        try await canPerform()
        return email != currentUser?.email
    }
    
    func deleteUserPhoto() async throws  -> AuthUser {
        try await canPerform()
        currentUser = PreviewUser(email: currentUser?.email, name: currentUser?.displayName, avatarURL: nil)
        return currentUser!
    }
}

// MARK: Private

extension PreviewUserRepository {

    private func canPerform() async throws {
        if AppFlags.isTesting {
            try await Task.sleep(nanoseconds: 500_000_000)
        } else {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
        try checkError()
    }

    private func checkError() throws {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
    }
}
