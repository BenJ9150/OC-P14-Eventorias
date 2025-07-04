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
        successAlert.assertExists(withButtons: ["Sign out", "Cancel"])
        successAlert.buttons["Sign out"].tap()

        // Then user is disconnected
        app.assertSignInViewIsVisible()
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
        needAuthAlert.assertExists(withButtons: ["Sign out", "Cancel"])
        needAuthAlert.buttons["Sign out"].tap()

        // Then user is disconnected
        app.assertSignInViewIsVisible()

        // And old email is already set
        app.buttons["Sign in with email"].tap()
        XCTAssertEqual(app.textFields["Email"].value as? String, AppFlags.previewEmail)
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
        needPermissionAlert.assertExists(withButtons: ["Open Settings", "Cancel"])
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
        // Placeholder of avatar not exist (there is an avatar)
        app.images["ProfileIcon"].assertNotExists()

        // Given user clic on avatar
        app.buttons["UserAvatar"].tap()

        // When clic on delete button
        app.buttons["Delete avatar"].tap()

        // And update button
        app.buttons["Update"].tap()

        // Then avatar is deleted (placeholder is shown)
        app.images["ProfileIcon"].assertExists()
    }
}
