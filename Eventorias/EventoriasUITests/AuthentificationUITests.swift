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
    }

    func test_EmailSignIn() {
        XCUIDevice.shared.orientation = .landscapeLeft
        app.launch()

        // Given user is on sign in with email view
        app.buttons["Sign in with email"].tap()
    
        // When user enters email and password
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("test@gmail.com")
        app.keyboards.buttons["suivant"].tap()
        app.secureTextFields["Password"].typeText("test")

        // And user taps on sign in button
        app.keyboards.buttons["rejoindre"].tap()

        // Then user should be redirected to the main view
        app.assertMainViewIsVisible()
    }

    func test_EmailSignInEmptyField() throws {
        XCUIDevice.shared.orientation = .portrait
        app.launch()

        // Given user is on sign in with email view
        app.buttons["Sign in with email"].tap()

        // When user tap on sign in button
        app.buttons["Sign in"].tap()

        // Then 2 textfields are required
        app.assertStaticTextsCount("This field is required.", count: 2)
    }
}

// MARK: Sign Up

final class SignUpUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTestingSignIn)
        app.launch()
        app.buttons["GoToSignUp"].tap()
    }

    func test_SignUp() {
        // Given user enters email, password and name
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("test@gmail.com")
        app.keyboards.buttons["suivant"].tap()
        app.secureTextFields["Password"].typeText("test")
        app.keyboards.buttons["suivant"].tap()
        app.textFields["Name"].typeText("test")

        // When user taps on sign up button
        app.keyboards.buttons["rejoindre"].tap()

        // Then user should be redirected to the main view
        app.assertMainViewIsVisible()
    }

    func test_SignUpEmptyField() throws {
        // Given user tap on sign up button
        app.buttons["Sign up"].tap()

        // Then 2 textfields are required (name is optional)
        app.assertStaticTextsCount("This field is required.", count: 2)
    }
}

// MARK: Forgot password

final class ForgotPwdUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTestingSignIn)
        app.launch()
        app.buttons["Sign in with email"].tap()
        app.buttons["Forgot password?"].tap()
    }

    func test_ForgotPassword() {
        // Given user enters email
        app.textFields["EmailPasswordReset"].tap()
        app.textFields["EmailPasswordReset"].typeText("test@gmail.com")

        // When tap on send password reset button
        app.keyboards.buttons["envoyer"].tap()
    
        // Then success message is presented
        app.assertStaticTextExists("Password reset email sent successfully!")
    }

    func test_ForgotPasswordEmptyField() {
        // Given user tap on send password reset button
        app.buttons["Send password reset"].tap()

        // Then a textfield is required
        app.assertStaticTextsCount("This field is required.", count: 1)
    }
}

// MARK: Sign out

final class SignOutUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .landscapeLeft
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
        app.assertSignInViewIsVisible()
    }
}
