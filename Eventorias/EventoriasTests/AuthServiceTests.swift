//
//  AuthServiceTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import XCTest
@testable import Eventorias

final class AuthServiceTests: XCTestCase {

    // MARK: Update user

    func test_UpdateUserSuccess() async throws {
        // Given valid data
        let authService = AuthService(authRepo: MockAuthRepository(isConnected: true))
        let userName = "test"
        let photoUrl = "https://www.test.com"

        // When update user
        try await authService.updateUser(displayName: userName, photoURL: photoUrl)

        // Then user is updated
        XCTAssertEqual(authService.authRepo.currentUser?.displayName, userName)
        XCTAssertEqual(authService.authRepo.currentUser?.photoURL?.absoluteString, photoUrl)
    }

    func test_UpdateInvalidUser() async throws {
        // Given user is nil
        let authService = AuthService(authRepo: MockAuthRepository())
        let userName = "test"
        let photoUrl = "https://www.test.com"

        // When update user
        do {
            try await authService.updateUser(displayName: userName, photoURL: photoUrl)
        } catch {
            // Then an error is throw
            let appError = error as! AppError
            XCTAssertEqual(appError.userMessage, "User could not be found")
        }
    }

    func test_UpdateEmptyData() async throws {
        // Given user is connected
        let authService = AuthService(authRepo: MockAuthRepository(isConnected: true))
        let oldUserName = authService.authRepo.currentUser!.displayName
        let oldPhotoUrl = authService.authRepo.currentUser!.photoURL!.absoluteString

        // When update user with empty data
        try await authService.updateUser(displayName: "", photoURL: "")

        // Then user is not updated
        XCTAssertEqual(authService.authRepo.currentUser?.displayName, oldUserName)
        XCTAssertEqual(authService.authRepo.currentUser?.photoURL?.absoluteString, oldPhotoUrl)
    }
}
