//
//  AuthentificationUITests.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2025.
//

import XCTest

// MARK: Sign In

final class SignInUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTestingSignIn)
        app.launch()
    }

    func test_EmailSignIn() {
        // Given user is on sign in with email view
        app.buttons["Sign in with email"].tap()
        let emailField = app.textFields["Email"]
        let pwdField = app.secureTextFields["Password"]
    
        // When user enters email and password
        emailField.tap()
        emailField.typeText("test@gmail.com")
        pwdField.tap()
        pwdField.typeText("test")

        // And user taps on sign in button
        app.buttons["Sign in"].tap()

        // Then user should be redirected to the main view
        let searchFieldOfMainView = app.textFields["Search"]
        XCTAssertTrue(searchFieldOfMainView.waitForExistence(timeout: 2))
    }

    func test_EmailSignInEmptyField() throws {
        // Given user is on sign in with email view
        app.buttons["Sign in with email"].tap()

        // When user tap on sign in button
        app.buttons["Sign in"].tap()

        // Then 2 textfields are required
        let errors = app.staticTexts.matching(identifier: "This field is required.")
        _ = errors.firstMatch.waitForExistence(timeout: 2)
        XCTAssertEqual(errors.count, 2)
    }
}

// MARK: Sign Up

final class SignUpUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTestingSignIn)
        app.launch()
    }

    func test_SignUp() {
        // Given user is on sign up view
        app.buttons["GoToSignUp"].tap()
        let emailField = app.textFields["Email"]
        let pwdField = app.secureTextFields["Password"]
        let nameField = app.textFields["Name"]
    
        // When user enters email, password and name
        emailField.tap()
        emailField.typeText("test@gmail.com")
        pwdField.tap()
        pwdField.typeText("test")
        nameField.tap()
        nameField.typeText("test")

        // And user taps on sign up button
        app.buttons["Sign up"].tap()

        // Then user should be redirected to the main view
        let searchFieldOfMainView = app.textFields["Search"]
        XCTAssertTrue(searchFieldOfMainView.waitForExistence(timeout: 2))
    }

    func test_SignUpEmptyField() throws {
        // Given user is on sign up view
        app.buttons["GoToSignUp"].tap()

        // When user tap on sign up button
        app.buttons["Sign up"].tap()

        // Then 2 textfields are required (name is optional)
        let errors = app.staticTexts.matching(identifier: "This field is required.")
        _ = errors.firstMatch.waitForExistence(timeout: 2)
        XCTAssertEqual(errors.count, 2)
    }
}

// MARK: Forgot password

final class ForgotPwdUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTestingSignIn)
        app.launch()
    }

    func test_ForgotPassword() {
        // Given user is on forgot password view
        app.buttons["Sign in with email"].tap()
        app.buttons["Forgot password?"].tap()
        let emailField = app.textFields["EmailPasswordReset"]
    
        // When user enters email
        emailField.tap()
        emailField.typeText("test@gmail.com")

        // And tap on send password reset button
        app.buttons["Send password reset"].tap()
    
        // Then success message is presented
        let successMessage = app.staticTexts["Password reset email sent successfully!"]
        let successMessageExist = successMessage.waitForExistence(timeout: 2)
        XCTAssertTrue(successMessageExist)
    }

    func test_ForgotPasswordEmailOnSignInView() {
        // Given user is on sign in with email view and enters email
        app.buttons["Sign in with email"].tap()
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("test@gmail.com")
        
        // When user tap on forgot password button
        app.buttons["Forgot password?"].tap()

        // And tap on send password reset button
        app.buttons["Send password reset"].tap()
    
        // Then success message is presented
        let successMessage = app.staticTexts["Password reset email sent successfully!"]
        let successMessageExist = successMessage.waitForExistence(timeout: 2)
        XCTAssertTrue(successMessageExist)
    }

    func test_ForgotPasswordEmptyField() {
        // Given user is on forgot password view
        app.buttons["Sign in with email"].tap()
        app.buttons["Forgot password?"].tap()
    
        // When user tap on send password reset button
        app.buttons["Send password reset"].tap()

        // Then there is an error
        let error = app.staticTexts["This field is required."]
        let errorExist = error.waitForExistence(timeout: 2)
        XCTAssertTrue(errorExist)
    }
}

// MARK: Sign out

final class SignOutUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
    }

    func test_SignOut() {
        // Given user is on profile view
        app.buttons["Profile"].tap()

        // When clic on sign out button
        app.buttons["Sign out"].tap()

        // Then user is disconnected
        let signInViewButton = app.buttons["Sign in with email"]
        XCTAssertTrue(signInViewButton.waitForExistence(timeout: 2))
    }
}
