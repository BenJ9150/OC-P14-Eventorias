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
        // Given valid data
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())
        XCTAssertNil(viewModel.currentUser)
        viewModel.email = "test@test.com"
        viewModel.password = "test"
        
        // When sign in
        await viewModel.signIn()
        
        // Then user is not nil and no error is displayed
        XCTAssertNotNil(viewModel.currentUser)
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
        XCTAssertEqual(viewModel.emailError, AppError.invalidEmailFormat.userMessage)
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, "")
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
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, AppError.invalidCredentials.userMessage)
    }
}

// MARK: Reset password

extension EventoriasTests {

    func test_ResetPasswordSuccess() async {
        // Given email to reset is valid
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())
        viewModel.email = "test@test.com"

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then success message is displayed with no error
        XCTAssertEqual(viewModel.resetPasswordSuccess, "Password reset email sent successfully!")
        XCTAssertEqual(viewModel.resetPasswordError, "")
    }

    func test_ResetPasswordFailure() async {
        // Given unknown error
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(withError: 0))
        viewModel.email = "test@test.com"

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.unknown.userMessage)
    }

    func test_ResetPasswordEmptyEmail() async {
        // Given email to reset is empty
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.emptyField.userMessage)
    }

    func test_ResetPasswordInvalidEmailFormat() async {
        // Given invalid email format
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(withError: 17008))
        viewModel.email = "test.com"

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.invalidEmailFormat.userMessage)
    }
}


// MARK: Sign out

extension EventoriasTests {

    func test_SignOutSuccess() {
        // Given user is connected
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(isConnected: true))
        XCTAssertNotNil(viewModel.currentUser)

        // When sign out
        viewModel.signOut()

        // Then user is nil and no error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, "")
    }

    func test_SignOutFailure() {
        // Given user is connected but network issue
        let viewModel = AuthViewModel(authRepo: MockAuthRepository(withError: 17020, isConnected: true))
        XCTAssertNotNil(viewModel.currentUser)

        // When sign out
        viewModel.signOut()

        // Then user is not nil and error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, AppError.networkError.userMessage)
    }
}
