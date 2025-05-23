//
//  PreviewAuthRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import Foundation

// MARK: Preview AuthRepository

class PreviewAuthRepository: AuthRepository {

    
    private var codeError: Int?

    // MARK: Init

    init(withError codeError: Int? = nil, isConnected: Bool = true) {
        self.codeError = codeError
        if isConnected {
            currentUser = PreviewUser()
        }
    }

    // MARK: AuthRepository protocol

    var currentUser: AuthUser?

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
        let user = PreviewUser(email: email)
        currentUser = user
        return user
    }

    func sendPasswordReset(withEmail email: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
    }

    func signOut() throws {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
        currentUser = nil
    }

    func createUser(withEmail email: String, password: String) async throws -> AuthUser {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
        let user = PreviewUser(email: email)
        currentUser = user
        return user
    }

    func updateUser(displayName: String, photoURL: URL?) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
        guard let user = currentUser as? PreviewUser else {
            throw AppError.currentUserNotFound
        }
        var changeRequest = user.createUserProfileChangeRequest()
        changeRequest.displayName = displayName
        changeRequest.photoURL = photoURL
        try await changeRequest.commitChanges()
    }
}

// MARK: Preview AuthUser

struct PreviewUser: AuthUser {
    var uid = UUID().uuidString
    var email: String? = "preview@eventorias.com"
    var displayName: String? = "Jean-Baptiste"
    var photoURL: URL? = nil

    func createUserProfileChangeRequest() -> AuthUserProfile {
        PreviewUserProfile()
    }
}

struct PreviewUserProfile: AuthUserProfile {
    var displayName: String?
    var photoURL: URL?
    
    func commitChanges() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
