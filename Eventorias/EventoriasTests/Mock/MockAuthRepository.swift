//
//  MockAuthRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation
@testable import Eventorias

class MockAuthRepository: AuthRepository {

    var currentUser: AuthUser?
    private var codeError: Int?

    init(withError codeError: Int? = nil, isConnected: Bool = false) {
        self.codeError = codeError
        if isConnected {
            currentUser = MockUser()
        }
    }

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
        let user = MockUser(email: email)
        currentUser = user
        return user
    }

    func sendPasswordReset(withEmail email: String) async throws {
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
}
