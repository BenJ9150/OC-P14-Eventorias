//
//  PreviewAuthRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import Foundation

// MARK: Preview AuthRepository

class PreviewAuthRepository: AuthRepository {

    var currentUser: AuthUser?
    private var codeError: Int?

    init(withError codeError: Int? = nil, isConnected: Bool = true) {
        self.codeError = codeError
        if isConnected {
            currentUser = PreviewUser()
        }
    }

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

    func signOut() throws {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
        currentUser = nil
    }
}

// MARK: Preview AuthUser

struct PreviewUser: AuthUser {
    var uid = UUID().uuidString
    var email: String? = "preview@eventorias.com"
    var displayName: String? = "Jean-Baptiste"
    var photoURL: URL? = nil
}
