//
//  ProfileViewUITests.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2025.
//

import XCTest

final class ProfileViewUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
}

// MARK: Sign out

extension ProfileViewUITests {

    func test_SignOut() {
        // Given user is on profile view
        launchProfileView(withArg: AppFlags.uiTesting)

        // When clic on sign out button
        app.buttons["Sign out"].tap()

        // Then user is disconnected
        let signInViewButton = app.buttons["Sign in with email"]
        XCTAssertTrue(signInViewButton.waitForExistence(timeout: 2))
    }
}

// MARK: Update name and email

extension ProfileViewUITests {

    func test_UpdateEmailNeedNewAuth() {
        launchProfileView(withArg: AppFlags.uiTestingUpdateNeedAuth)

        // Given user has changed his email (and he's connected from long time)
        clearAndTypeText(app.textFields["Email"], text: "test@gmail.com")
        app.buttons["Update"].tap()

        // When clic on sign out button of alert "This operation requires recent authentication"
        let needAuthAlert = app.alerts["This operation requires recent authentication. Please sign out and log in again before trying to update your email"]
        XCTAssertTrue(needAuthAlert.waitForExistence(timeout: 2))
        XCTAssertTrue(needAuthAlert.buttons["Sign out"].exists)
        XCTAssertTrue(needAuthAlert.buttons["Cancel"].exists)
        needAuthAlert.buttons["Sign out"].tap()

        // Then user is disconnected
        let signInViewButton = app.buttons["Sign in with email"]
        XCTAssertTrue(signInViewButton.waitForExistence(timeout: 2))

        // And old email is already set
        signInViewButton.tap()
        let signInEmailField = app.textFields["Email"]
        XCTAssertEqual(signInEmailField.value as? String, AppFlags.previewEmail)
    }

    func test_UpdateNameAndEmailSuccess() {
        launchProfileView(withArg: AppFlags.uiTesting)

        // Given user has changed his name and email
        clearAndTypeText(app.textFields["Name"], text: "test")
        clearAndTypeText(app.textFields["Email"], text: "test@gmail.com")
        app.buttons["Update"].tap()

        // When clic on sign out button of alert "Confirmation email has been sent"
        let successAlert = app.alerts["Success!"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 2))
        XCTAssertTrue(successAlert.buttons["Sign out"].exists)
        XCTAssertTrue(successAlert.buttons["Cancel"].exists)
        successAlert.buttons["Sign out"].tap()

        // Then user is disconnected
        let signInViewButton = app.buttons["Sign in with email"]
        XCTAssertTrue(signInViewButton.waitForExistence(timeout: 2))
    }

    func test_UpdateNameAndEmailCancel() {
        launchProfileView(withArg: AppFlags.uiTesting)

        // Given user has changed his name and email
        let nameField = app.textFields["Name"]
        let emailField = app.textFields["Email"]
        clearAndTypeText(nameField, text: "test")
        clearAndTypeText(emailField, text: "test@gmail.com")

        // When clic on cancel button
        app.buttons["Cancel"].tap()

        // Then old name and email are set
        XCTAssertEqual(nameField.value as? String, AppFlags.previewName)
        XCTAssertEqual(emailField.value as? String, AppFlags.previewEmail)
    }
}

// MARK: Notifications

extension ProfileViewUITests {

    func test_NotificationsNeedPermission() {
        launchProfileView(withArg: AppFlags.uiTestingNotif)

        // Given user clic on notifications toggle
        let notifSwitch = app.switches["Notifications"]
        notifSwitch.tap()

        // When clic on cancel button of alert "We need your permission to send notifications"
        let needPermissionAlert = app.alerts["We need your permission to send notifications"]
        XCTAssertTrue(needPermissionAlert.waitForExistence(timeout: 2))
        XCTAssertTrue(needPermissionAlert.buttons["Open Settings"].exists)
        XCTAssertTrue(needPermissionAlert.buttons["Cancel"].exists)
        needPermissionAlert.buttons["Cancel"].tap()

        // Then toggle is not activated
        XCTAssertEqual(notifSwitch.value as? String, "0")
    }
}

// MARK: Avatar

extension ProfileViewUITests {

    func test_DeleteAvatar() {
        launchProfileView(withArg: AppFlags.uiTestingNotif)
        let avatarPlaceholder = app.images["ProfileIcon"]
        XCTAssertFalse(avatarPlaceholder.exists)

        // Given user clic on avatar
        app.buttons["UserAvatar"].tap()

        // When clic on delete button
        app.buttons["Delete avatar"].tap()

        // And update button
        app.buttons["Update"].tap()

        // Then avatar is deleted (placeholder is shown)
        XCTAssertTrue(avatarPlaceholder.exists)
    }
}

// MARK: Private

private extension ProfileViewUITests {

    func launchProfileView(withArg argument: String) {
        app.launchArguments.append(argument)
        app.launch()
        app.buttons["Profile"].tap()
    }

    func clearAndTypeText(_ element: XCUIElement, text: String) {
        guard let stringValue = element.value as? String else {
            element.typeText(text)
            return
        }
        element.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        element.typeText(deleteString)
        element.typeText(text)
    }
}
