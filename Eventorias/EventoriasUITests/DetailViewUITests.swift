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
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
    }

    func test_ToggleParticipate() {
        // Given user is on a detail view
        XCUIDevice.shared.orientation = .portrait
        app.launch()
        app.assertStaticTextExists("Charity run")
        app.staticTexts["Charity run"].tap()

        // And not participate to the event
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
        // Given user is on a detail view
        XCUIDevice.shared.orientation = .landscapeLeft
        app.launch()
        app.assertStaticTextExists("Charity run")
        app.staticTexts["Charity run"].tap()

        // When user tap on share button
        let shareButton = app.buttons["Share"]
        shareButton.assertExists()
        shareButton.tap()

        // Then share sheet is presented
        app.otherElements["ShareSheet.RemoteContainerView"].assertExists()
    }
}
