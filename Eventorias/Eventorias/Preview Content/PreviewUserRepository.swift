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
        let user = PreviewUser(email: email, name: name)
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
        try checkError()
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
    
    func udpateUser(name: String, avatar: UIImage?) async throws {
        try await canPerform()
        guard let user = currentUser as? PreviewUser else {
            throw AppError.currentUserNotFound
        }
        var changeRequest = user.createUserProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
    }
    
    func udpateUser(email: String) async throws -> Bool {
        try await canPerform()
        return email != currentUser?.email
    }
    
    func deleteUserPhoto() async throws {
        try await canPerform()
        guard let user = currentUser as? PreviewUser else {
            throw AppError.currentUserNotFound
        }
        var changeRequest = user.createUserProfileChangeRequest()
        changeRequest.photoURL = nil
        try await changeRequest.commitChanges()
    }
}

// MARK: Private

extension PreviewUserRepository {

    private func canPerform() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        try checkError()
    }

    private func checkError() throws {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
    }
}
