//
//  MockAuthService.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation
@testable import Eventorias

class MockAuthService: AuthRepository {

    var currentUser: AuthUser?
    private var codeError: Int?

    init(withError codeError: Int? = nil) {
        self.codeError = codeError
    }

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        if let error = codeError {
            let appError = AppError(forCode: error)
            throw NSError(domain: appError.userMessage, code: appError.rawValue)
        }
        return MockUser()
    }
}
