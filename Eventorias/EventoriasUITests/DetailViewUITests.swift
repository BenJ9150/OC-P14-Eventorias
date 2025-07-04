//
//  DetailViewUITests.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 04/07/2025.
//

import XCTest

final class DetailViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
        app.assertStaticTextExists("Charity run")
        app.staticTexts["Charity run"].tap()
    }

    func test_ToggleParticipate() {
        // Given user not participate
        let participateSwitch = app.switches["Participate"]
        participateSwitch.assertExists()
        XCTAssertEqual(participateSwitch.value as? String, "0")

        // When user tap on participate switch
        participateSwitch.tap()

        // Then toggle is activated
        XCTAssertEqual(participateSwitch.value as? String, "1")
        app.assertStaticTextExists("I participate")
    }

    func test_ShareEvent() {
        XCUIDevice.shared.orientation = .landscapeLeft

        // Given user is on a detail view
        let shareButton = app.buttons["Share"]
        shareButton.assertExists()

        // When user tap on share button
        shareButton.tap()

        // Then share sheet is presented
        app.otherElements["ShareSheet.RemoteContainerView"].assertExists()
    }
}
