//
//  AuthViewModelTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import XCTest
@testable import Eventorias

@MainActor final class AuthViewModelTests: XCTestCase {

    // MARK: Sign Up

    func test_SignUpSuccess() async {
        // Given valid data
        let viewModel = AuthViewModel(userRepo: MockUserRepository())
        XCTAssertNil(viewModel.currentUser)
        viewModel.email = "testNewUser@test.com"
        viewModel.password = "xxxxxx"
        viewModel.userName = "NameNewUser"

        // When sign up
        await viewModel.signUp()

        // Then user is not nil and no error is displayed
        XCTAssertEqual(viewModel.currentUser!.email, "testNewUser@test.com")
        XCTAssertEqual(viewModel.email, "testNewUser@test.com")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.currentUser!.displayName, "NameNewUser")
        XCTAssertEqual(viewModel.userName, "NameNewUser")
        XCTAssertEqual(viewModel.signUpError, "")
    }

    func test_SignUpEmptyFields() async {
        // Given empty sign up fields
        let viewModel = AuthViewModel(userRepo: MockUserRepository())

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
        let userRepo = MockUserRepository(withError: 17008)
        let viewModel = AuthViewModel(userRepo: userRepo)
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
        let userRepo = MockUserRepository(withError: 17007)
        let viewModel = AuthViewModel(userRepo: userRepo)
        viewModel.email = userRepo.user.email!
        viewModel.password = "xxxxxx"

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
        let userRepo = MockUserRepository(withError: 17026)
        let viewModel = AuthViewModel(userRepo: userRepo)
        viewModel.email = "testNewUser@test.com"
        viewModel.password = "xxxxxx"

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

extension AuthViewModelTests {

    func test_SignInSuccess() async {
        // Given valid data
        let userRepo = MockUserRepository()
        let viewModel = AuthViewModel(userRepo: userRepo)
        XCTAssertNil(viewModel.currentUser)
        viewModel.email = userRepo.user.email!
        viewModel.password = "xxxxxx"
        
        // When sign in
        await viewModel.signIn()

        // Then user is not nil and no error is displayed
        XCTAssertEqual(viewModel.currentUser!.email, userRepo.user.email!)
        XCTAssertEqual(viewModel.email, userRepo.user.email!)
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.userName, userRepo.user.displayName!)
        XCTAssertEqual(viewModel.userPhoto, userRepo.user.avatarURL!.absoluteString)
        XCTAssertEqual(viewModel.emailError, "")
        XCTAssertEqual(viewModel.pwdError, "")
        XCTAssertEqual(viewModel.signInError, "")
    }

    func test_SignInEmptyFields() async {
        // Given empty sign in fields
        let viewModel = AuthViewModel(userRepo: MockUserRepository())

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
        let userRepo = MockUserRepository(withError: 17008)
        let viewModel = AuthViewModel(userRepo: userRepo)
        viewModel.email = "test.com"
        viewModel.password = "xxxxxx"

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
        let userRepo = MockUserRepository(withError: 17004)
        let viewModel = AuthViewModel(userRepo: userRepo)
        viewModel.email = "testUnkown@test.com"
        viewModel.password = "xxxxxx"

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

extension AuthViewModelTests {

    func test_ResetPasswordSuccess() async {
        // Given email to reset is valid
        let userRepo = MockUserRepository()
        let viewModel = AuthViewModel(userRepo: userRepo)
        viewModel.email = userRepo.user.email!

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then success message is displayed with no error
        XCTAssertEqual(viewModel.resetPasswordSuccess, "Password reset email sent successfully!")
        XCTAssertEqual(viewModel.resetPasswordError, "")
    }

    func test_ResetPasswordFailure() async {
        // Given unknown error
        let userRepo = MockUserRepository(withError: 97354846)
        let viewModel = AuthViewModel(userRepo: userRepo)
        viewModel.email = userRepo.user.email!

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.unknown.userMessage)
    }

    func test_ResetPasswordEmptyEmail() async {
        // Given email to reset is empty
        let viewModel = AuthViewModel(userRepo: MockUserRepository())

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.emptyField.userMessage)
    }

    func test_ResetPasswordInvalidEmailFormat() async {
        // Given invalid email format
        let userRepo = MockUserRepository(withError: 17008)
        let viewModel = AuthViewModel(userRepo: userRepo)
        viewModel.email = "test.com"

        // When send password reset
        await viewModel.sendPasswordReset()

        // Then error is displayed with no success message
        XCTAssertEqual(viewModel.resetPasswordSuccess, "")
        XCTAssertEqual(viewModel.resetPasswordError, AppError.invalidEmailFormat.userMessage)
    }
}


// MARK: Sign out

extension AuthViewModelTests {

    func test_SignOutSuccess() {
        // Given user is connected
        let userRepo = MockUserRepository(isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)

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
        let userRepo = MockUserRepository(withError: 17020, isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)

        // When sign out
        viewModel.signOut()

        // Then user is not nil and error is displayed
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.signOutError, AppError.networkError.userMessage)
    }
}

// MARK: Update

extension AuthViewModelTests {

    func test_updateButtonsAreHidden() {
        // Given user is connected
        let userRepo = MockUserRepository(isConnected: true, withAvatar: false)
        let viewModel = AuthViewModel(userRepo: userRepo)

        // When checking if need to show update buttons
        viewModel.showUpdateButtonsIfNeeded()

        // Then is update buttons are hidden
        XCTAssertFalse(viewModel.showUpdateButtons)
    }

    func test_updateButtonsArePresented() {
        // Given user is connected
        let userRepo = MockUserRepository(isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)

        // And is removing avatar
        viewModel.userPhoto = ""

        // When checking if need to show update buttons
        viewModel.showUpdateButtonsIfNeeded()

        // Then buttons are presented
        XCTAssertTrue(viewModel.showUpdateButtons)
    }

    func test_UpdateNameAndMailSuccess() async {
        // Given user is connected
        let userRepo = MockUserRepository(isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)

        // When update name and email
        viewModel.userName = "TestUpdate"
        viewModel.email = "testupdate@test.com"
        await viewModel.udpate()

        // Then user name is updated without error
        XCTAssertEqual(viewModel.currentUser!.displayName, "TestUpdate")
        XCTAssertEqual(viewModel.userName, "TestUpdate")
        XCTAssertTrue(viewModel.updateError.isEmpty)

        // New email is presented just locally
        XCTAssertEqual(viewModel.currentUser!.email, userRepo.user.email!)
        XCTAssertEqual(viewModel.email, "testupdate@test.com")

        // and alert for new email is presented
        XCTAssertTrue(viewModel.showConfirmEmailAlert)
    }

    func test_UpdateAvatarSuccess() async {
        // Given user is connected
        let userRepo = MockUserRepository(isConnected: true, withAvatar: false)
        let viewModel = AuthViewModel(userRepo: userRepo)
        XCTAssertTrue(viewModel.userPhoto.isEmpty)

        // When update avatar
        viewModel.newAvatar = MockData().image()
        await viewModel.udpate()

        // Then photo URL is updated without error
        XCTAssertFalse(viewModel.currentUser!.avatarURL!.absoluteString.isEmpty)
        XCTAssertFalse(viewModel.userPhoto.isEmpty)
        XCTAssertTrue(viewModel.updateError.isEmpty)
    }

    func test_UpdateEmailNeedAuth() async {
        // Given user is connected from long time
        let userRepo = MockUserRepository(withError: 17014, isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)

        // When update user email
        viewModel.email = "testupdate@test.com"
        await viewModel.udpate()

        // Then alert for new auth is presented
        XCTAssertTrue(viewModel.showNeedAuthAlert)
        XCTAssertTrue(viewModel.updateError.isEmpty)

        // And when user sign out to refresh auth
        viewModel.signOutToRefreshAuth()

        // Then old email is saved for sign in view
        XCTAssertEqual(viewModel.email, userRepo.user.email!)
    }

    func test_UpdateFailureCauseAvatar() async {
        // Given user is connected
        let userRepo = MockUserRepository(isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)

        // When update avatar with invalid image
        viewModel.newAvatar = UIImage()
        await viewModel.udpate()

        // Then there is an error message
        XCTAssertEqual(viewModel.updateError, AppError.invalidImage.userMessage)
    }

    func test_UpdateFailureCauseNetwork() async {
        // Given network error
        let userRepo = MockUserRepository(withError: 17020, isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)

        // When update user
        viewModel.userName = "TestUpdate"
        await viewModel.udpate()

        // Then there is an error message
        XCTAssertEqual(viewModel.updateError, AppError.networkError.userMessage)
    }

    func test_UpdateFailureCauseNoUser() async {
        // Given no user
        let viewModel = AuthViewModel(userRepo: MockUserRepository())

        // When update user
        viewModel.userName = "TestUpdate"
        await viewModel.udpate()

        // Then there is an error message
        XCTAssertEqual(viewModel.updateError, AppError.currentUserNotFound.userMessage)
    }

    func test_CancelUpdate() async {
        // Given user is connected
        let userRepo = MockUserRepository(isConnected: true)
        let viewModel = AuthViewModel(userRepo: userRepo)
        await viewModel.reloadCurrentUser()

        // And user has changed his profile
        viewModel.userName = "TestUpdateCancel"
        viewModel.email = "testupdatecancel@test.com"
        viewModel.newAvatar = MockData().image()

        // When update is canceled
        viewModel.cancelProfileUpdate()

        // Then user profile is refresh with old data
        XCTAssertEqual(viewModel.userName, userRepo.user.displayName)
        XCTAssertEqual(viewModel.email, userRepo.user.email)
        XCTAssertEqual(viewModel.userPhoto, userRepo.user.avatarURL!.absoluteString)
        XCTAssertNil(viewModel.newAvatar)
    }
}
