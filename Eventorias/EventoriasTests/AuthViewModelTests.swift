//
//  AuthViewModelTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import XCTest
@testable import Eventorias

@MainActor final class EventoriasTests: XCTestCase {

    // MARK: Sign Up

    func test_SignUpSuccess() async {
        // Given valid data
        let viewModel = AuthViewModel(authService: AuthService(authRepo: MockAuthRepository()))
        XCTAssertNil(viewModel.currentUser)
        viewModel.email = "test@test.com"
        viewModel.password = "xxxxxx"
        viewModel.userName = "test"
        viewModel.userPhoto = "https://www.test.com"

        // When sign up
        await viewModel.signUp()

        // Then user is not nil and no error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.currentUser!.email, "test@test.com")
        XCTAssertEqual(viewModel.currentUser!.displayName, "test")
        XCTAssertEqual(viewModel.currentUser!.photoURL!.absoluteString, "https://www.test.com")
        XCTAssertEqual(viewModel.signUpError, "")
    }

    func test_SignUpFailure() async {
        // Given valid data but network issue
        let authRepo = MockAuthRepository(withError: 17020)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
        viewModel.email = "test@test.com"
        viewModel.password = "test"

        // When sign up
        await viewModel.signUp()

        // Then user is nil and error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signUpError, AppError.networkError.userMessage)
    }

    func test_SignUpEmptyFields() async {
        // Given empty sign up fields
        let viewModel = AuthViewModel(authService: AuthService(authRepo: MockAuthRepository()))

        // When sign up
        await viewModel.signUp()

        // Then user is nil and errors are displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.emailError, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.pwdError, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.signUpError, "")
    }

    func test_SignUpInvalidEmailFormat() async {
        // Given invalid email format
        let authRepo = MockAuthRepository(withError: 17008)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
        viewModel.email = "test.com"
        viewModel.password = "test"

        // When sign up
        await viewModel.signUp()

        // Then user is nil and error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.emailError, AppError.invalidEmailFormat.userMessage)
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signUpError, "")
    }
}

// MARK: Sign in

extension EventoriasTests {

    func test_SignInSuccess() async {
        // Given valid data
        let viewModel = AuthViewModel(authService: AuthService(authRepo: MockAuthRepository()))
        XCTAssertNil(viewModel.currentUser)
        viewModel.email = "test@test.com"
        viewModel.password = "test"
        
        // When sign in
        await viewModel.signIn()
        
        // Then user is not nil and no error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.currentUser!.email, "test@test.com")
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, "")
    }

    func test_SignInEmptyFields() async {
        // Given empty sign in fields
        let viewModel = AuthViewModel(authService: AuthService(authRepo: MockAuthRepository()))

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
        let authRepo = MockAuthRepository(withError: 17008)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
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
        let authRepo = MockAuthRepository(withError: 17004)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
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
        let viewModel = AuthViewModel(authService: AuthService(authRepo: MockAuthRepository()))
        viewModel.email = "test@test.com"

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then success message is displayed with no error
        XCTAssertEqual(viewModel.resetPasswordSuccess, "Password reset email sent successfully!")
        XCTAssertEqual(viewModel.resetPasswordError, "")
    }

    func test_ResetPasswordFailure() async {
        // Given unknown error
        let authRepo = MockAuthRepository(withError: 97354846)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
        viewModel.email = "test@test.com"

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.unknown.userMessage)
    }

    func test_ResetPasswordEmptyEmail() async {
        // Given email to reset is empty
        let viewModel = AuthViewModel(authService: AuthService(authRepo: MockAuthRepository()))

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.emptyField.userMessage)
    }

    func test_ResetPasswordInvalidEmailFormat() async {
        // Given invalid email format
        let authRepo = MockAuthRepository(withError: 17008)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
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
        let authRepo = MockAuthRepository(isConnected: true)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
        XCTAssertNotNil(viewModel.currentUser)

        // When sign out
        viewModel.signOut()

        // Then user is nil and no error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, "")
    }

    func test_SignOutFailure() {
        // Given user is connected but network issue
        let authRepo = MockAuthRepository(withError: 17020, isConnected: true)
        let viewModel = AuthViewModel(authService: AuthService(authRepo: authRepo))
        XCTAssertNotNil(viewModel.currentUser)

        // When sign out
        viewModel.signOut()

        // Then user is not nil and error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, AppError.networkError.userMessage)
    }
}
