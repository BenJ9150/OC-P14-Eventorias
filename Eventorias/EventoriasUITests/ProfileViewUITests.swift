//
//  ProfileViewUITests.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 28/06/2025.
//

import XCTest

// MARK: Update name and email

final class UpdateNameAndEmailUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
        app.buttons["Profile"].tap()
    }

    func test_UpdateNameAndEmailSuccess() {
        // Given user has changed his name and email
        app.textFields["Name"].clearAndTypeText("test")
        app.textFields["Email"].clearAndTypeText("test@gmail.com")
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
        // Given user has changed his name and email
        let nameField = app.textFields["Name"]
        let emailField = app.textFields["Email"]
        nameField.clearAndTypeText("test")
        emailField.clearAndTypeText("test@gmail.com")

        // When clic on cancel button
        app.buttons["Cancel"].tap()

        // Then old name and email are set
        XCTAssertEqual(nameField.value as? String, AppFlags.previewName)
        XCTAssertEqual(emailField.value as? String, AppFlags.previewEmail)
    }
}

// MARK: Update Email need auth

final class UpdateEmailNeedAuthUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTestingUpdateNeedAuth)
        app.launch()
        app.buttons["Profile"].tap()
    }

    func test_UpdateEmailNeedNewAuth() {
        // Given user has changed his email (and he's connected from long time)
        app.textFields["Email"].clearAndTypeText("test@gmail.com")
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
}

// MARK: Notifications

final class NotificationsUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTestingNotif)
        app.launch()
        app.buttons["Profile"].tap()
    }

    func test_NotificationsNeedPermission() {
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

final class AvatarUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
        app.buttons["Profile"].tap()
    }

    func test_DeleteAvatar() {
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

// MARK: Extension XCUIElement

private extension XCUIElement {

    func clearAndTypeText(_ text: String) {
        guard let stringValue = self.value as? String else {
            self.tap()
            self.typeText(text)
            return
        }
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
