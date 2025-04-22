//
//  AuthViewModelTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import XCTest
@testable import Eventorias

@MainActor final class EventoriasTests: XCTestCase {

    // MARK: Sign in

    func test_SignInSuccess() async {
        // Default values
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.isConnecting, false)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, "")

        // Given valid data
        viewModel.email = "test@test.com"
        viewModel.password = "test"

        // When sign in
        await viewModel.signIn()

        // Then user is not nil and no error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.isConnecting, false)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, "")
    }

    func test_SignInEmptyFields() async {
        // Given empty sign in fields
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())

        // When sign in
        await viewModel.signIn()

        // Then user is nil and errors are displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.isConnecting, false)
        XCTAssertEqual(viewModel.emailError, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.pwdError, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.signInError, "")
    }

    func test_SignInInvalidEmailFormat() async {
        // Given invalid email format
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(withError: 17008))
        viewModel.email = "test.com"
        viewModel.password = "test"

        // When sign in
        await viewModel.signIn()

        // Then user is nil and error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.isConnecting, false)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, AppError.invalidEmailFormat.userMessage)
    }

    func test_SignInInvalidCredentials() async {
        // Given invalid credentials
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(withError: 17004))
        viewModel.email = "test@test.com"
        viewModel.password = "test"

        // When sign in
        await viewModel.signIn()

        // Then user is nil and error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.isConnecting, false)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, AppError.invalidCredentials.userMessage)
    }

    // MARK: Sign out

    func test_SignOutSuccess() async {
        // Given user is connected
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(isConnected: true))
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, "")

        // When sign out
        viewModel.signOut()

        // Then user is nil and no error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, "")
    }

    func test_SignOutFailure() async {
        // Given user is connected but network issue
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(withError: 17020, isConnected: true))
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, "")

        // When sign out
        viewModel.signOut()

        // Then user is not nil and error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, AppError.networkError.userMessage)
    }
}
