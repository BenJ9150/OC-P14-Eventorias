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
        let viewModel = AuthViewModel(authRepo: MockAuthService())
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
        let viewModel = AuthViewModel(authRepo: MockAuthService())

        // When sign in
        await viewModel.signIn()

        // Then user is nil and errors are displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.isConnecting, false)
        XCTAssertEqual(viewModel.emailError, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.pwdError, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.signInError, "")
    }

    func test_SignInFailure() async {
        // Given invalid data
        let viewModel = AuthViewModel(authRepo: MockAuthService(withError: 17004))
        viewModel.email = "test@test.com"
        viewModel.password = "test"

        // When sign in
        await viewModel.signIn()

        // Then user is nil and error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.isConnecting, false)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, AppError(forCode: 17004).userMessage)
    }
}
