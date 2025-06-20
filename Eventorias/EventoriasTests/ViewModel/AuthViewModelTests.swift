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
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())
        XCTAssertNil(viewModel.currentUser)
        viewModel.email = "test@test.com"
        viewModel.password = "xxxxxx"
        viewModel.userName = "test"
        viewModel.userPhoto = "https://www.test.com"

        // When sign up
        await viewModel.signUp()

        // Then user is not nil and no error is displayed
        XCTAssertEqual(viewModel.currentUser!.email, "test@test.com")
        XCTAssertEqual(viewModel.email, "test@test.com")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.currentUser!.displayName, "test")
        XCTAssertEqual(viewModel.userName, "test")
        XCTAssertEqual(viewModel.currentUser!.avatarURL!.absoluteString, "https://www.test.com")
        XCTAssertEqual(viewModel.userPhoto, "https://www.test.com")
        XCTAssertEqual(viewModel.signUpError, "")
    }

    func test_SignUpEmptyFields() async {
        // Given empty sign up fields
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())

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
        let viewModel = AuthViewModel(authRepo: authRepo)
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

    func test_SignUpEmailAlreadyExist() async {
        // Given valid data but email already linked to an account
        let authRepo = MockAuthRepository(withError: 17007)
        let viewModel = AuthViewModel(authRepo: authRepo)
        viewModel.email = "test@test.com"
        viewModel.password = "test"

        // When sign up
        await viewModel.signUp()

        // Then user is nil and error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signUpError, AppError.emailAlreadyInUse.userMessage)
    }

    func test_SignUpWeakPassword() async {
        // Given password does not meet requirements
        let authRepo = MockAuthRepository(withError: 17026)
        let viewModel = AuthViewModel(authRepo: authRepo)
        viewModel.email = "test@test.com"
        viewModel.password = "test"

        // When sign up
        await viewModel.signUp()

        // Then user is nil and error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signUpError, AppError.weakPassword.userMessage)
    }
}

// MARK: Sign in

extension EventoriasTests {

    func test_SignInSuccess() async {
        // Given valid data
        let viewModel = AuthViewModel(authRepo: MockAuthRepository())
        XCTAssertNil(viewModel.currentUser)
        viewModel.email = "test@test.com"
        viewModel.password = "test"
        
        // When sign in
        await viewModel.signIn()
        
        // Then user is not nil and no error is displayed
        XCTAssertEqual(viewModel.currentUser!.email, "test@test.com")
        XCTAssertEqual(viewModel.email, "test@test.com")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.userName, "TestName")
        XCTAssertEqual(viewModel.userPhoto, "https://www.test.com")
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
        let authRepo = MockAuthRepository(withError: 17008)
        let viewModel = AuthViewModel(authRepo: authRepo)
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
        let viewModel = AuthViewModel(authRepo: authRepo)
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
        let authRepo = MockAuthRepository(withError: 97354846)
        let viewModel = AuthViewModel(authRepo: authRepo)
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
        let authRepo = MockAuthRepository(withError: 17008)
        let viewModel = AuthViewModel(authRepo: authRepo)
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
        let viewModel = AuthViewModel(authRepo: authRepo)

        // When sign out
        viewModel.signOut()

        // Then user is nil and no error is displayed
        XCTAssertNil(viewModel.currentUser)
        XCTAssertTrue(viewModel.email.isEmpty)
        XCTAssertTrue(viewModel.password.isEmpty)
        XCTAssertTrue(viewModel.userName.isEmpty)
        XCTAssertTrue(viewModel.userPhoto.isEmpty)
        XCTAssertTrue(viewModel.signOutError.isEmpty)
    }

    func test_SignOutFailure() {
        // Given user is connected but network issue
        let authRepo = MockAuthRepository(withError: 17020, isConnected: true)
        let viewModel = AuthViewModel(authRepo: authRepo)

        // When sign out
        viewModel.signOut()

        // Then user is not nil and error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, AppError.networkError.userMessage)
    }
}

// MARK: Update

extension EventoriasTests {

    func test_updateButtonsAreHidden() {
        // Given user is connected
        let authRepo = MockAuthRepository(isConnected: true, withAvatar: false)
        let viewModel = AuthViewModel(authRepo: authRepo)
        viewModel.refreshCurrentUser()

        // When checking if need to show update buttons
        viewModel.showUpdateButtonsIfNeeded()

        // Then is update buttons are hidden
        XCTAssertFalse(viewModel.showUpdateButtons)
    }

    func test_updateButtonsArePresented() {
        // Given user is connected
        let authRepo = MockAuthRepository(isConnected: true)
        let viewModel = AuthViewModel(authRepo: authRepo)
        viewModel.refreshCurrentUser()

        // And is removing avatar
        viewModel.userPhoto = ""

        // When checking if need to show update buttons
        viewModel.showUpdateButtonsIfNeeded()

        // Then buttons are presented
        XCTAssertTrue(viewModel.showUpdateButtons)
    }

    func test_UpdateNameAndMailSuccess() async {
        // Given user is connected
        let authRepo = MockAuthRepository(isConnected: true)
        let storageRepo = MockStorageRepository()
        let viewModel = AuthViewModel(authRepo: authRepo, storageRepo: storageRepo)
        viewModel.refreshCurrentUser()

        // When update name and email
        viewModel.userName = "TestUpdate"
        viewModel.email = "testupdate@test.com"
        await viewModel.udpate()

        // Then user name is updated without error
        XCTAssertEqual(viewModel.currentUser?.displayName, "TestUpdate")
        XCTAssertTrue(viewModel.updateError.isEmpty)

        // and alert for new email is presented
        XCTAssertTrue(viewModel.showConfirmEmailAlert)
    }

    func test_UpdateAvatarSuccess() async {
        // Given user is connected
        let authRepo = MockAuthRepository(isConnected: true)
        let storageRepo = MockStorageRepository()
        let viewModel = AuthViewModel(authRepo: authRepo, storageRepo: storageRepo)

        // When update avatar
        viewModel.newAvatar = MockData().image()
        await viewModel.udpate()

        // Then photo URL is updated without error
        XCTAssertEqual(viewModel.currentUser?.avatarURL?.absoluteString, "www.test-update.com")
        XCTAssertTrue(viewModel.updateError.isEmpty)
    }

    func test_UpdateEmailNeedAuth() async {
        // Given user is connected from long time
        let authRepo = MockAuthRepository(withError: 17014, isConnected: true)
        let storageRepo = MockStorageRepository()
        let viewModel = AuthViewModel(authRepo: authRepo, storageRepo: storageRepo)

        // When update user email
        viewModel.email = "testupdate@test.com"
        await viewModel.udpate()

        // Then alert for new auth is presented
        XCTAssertTrue(viewModel.showNeedAuthAlert)
        XCTAssertTrue(viewModel.updateError.isEmpty)

        // And when user sign out to refresh auth
        viewModel.signOutToRefreshAuth()

        // Then current email is saved for sign in view
        XCTAssertEqual(viewModel.email, "test@test.com")
    }

    func test_UpdateFailureCauseAvatar() async {
        // Given user is connected
        let authRepo = MockAuthRepository(isConnected: true)
        let storageRepo = MockStorageRepository()
        let viewModel = AuthViewModel(authRepo: authRepo, storageRepo: storageRepo)

        // When update avatar with invalid image
        viewModel.newAvatar = UIImage()
        await viewModel.udpate()

        // Then there is an error message
        XCTAssertEqual(viewModel.updateError, AppError.invalidImage.userMessage)
    }

    func test_UpdateFailureCauseNetwork() async {
        // Given network error
        let authRepo = MockAuthRepository(withError: 17020, isConnected: true)
        let storageRepo = MockStorageRepository()
        let viewModel = AuthViewModel(authRepo: authRepo, storageRepo: storageRepo)

        // When update user
        viewModel.userName = "TestUpdate"
        await viewModel.udpate()

        // Then there is an error message
        XCTAssertEqual(viewModel.updateError, AppError.networkError.userMessage)
    }

    func test_UpdateFailureCauseNoUser() async {
        // Given no user
        let authRepo = MockAuthRepository()
        let storageRepo = MockStorageRepository()
        let viewModel = AuthViewModel(authRepo: authRepo, storageRepo: storageRepo)

        // When update user
        viewModel.userName = "TestUpdate"
        await viewModel.udpate()

        // Then there is an error message
        XCTAssertEqual(viewModel.updateError, AppError.currentUserNotFound.userMessage)
    }

    func test_CancelUpdate() async {
        // Given user is connected
        let authRepo = MockAuthRepository(isConnected: true)
        let storageRepo = MockStorageRepository()
        let viewModel = AuthViewModel(authRepo: authRepo, storageRepo: storageRepo)
        await viewModel.reloadCurrentUser()
        let userBeforUpdate = viewModel.currentUser!

        // And user has changed his profile
        viewModel.userName = "TestUpdateCancel"
        viewModel.email = "testupdatecancel@test.com"
        viewModel.newAvatar = MockData().image()

        // When update is canceled
        viewModel.cancelProfileUpdate()

        // Then user profile is refresh with old data
        XCTAssertEqual(viewModel.userName, userBeforUpdate.displayName)
        XCTAssertEqual(viewModel.email, userBeforUpdate.email)
        XCTAssertEqual(viewModel.userPhoto, userBeforUpdate.avatarURL!.absoluteString)
        XCTAssertNil(viewModel.newAvatar)
    }
}
