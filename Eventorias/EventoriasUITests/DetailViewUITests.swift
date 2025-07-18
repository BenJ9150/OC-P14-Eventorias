//
//  DetailViewUITests.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 04/07/2025.
//

import XCTest

// MARK: Participate

final class ParticipateUITests: XCTestCase {

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
        disableNotifications(for: app)
        app.assertStaticTextExists("Charity run")
        app.staticTexts["Charity run"].tap()
        app.forceUIStabilization()

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
}

// MARK: Share event

final class ShareEventUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
    }

    func test_ShareEvent() {
        // Given user is on a detail view
        XCUIDevice.shared.orientation = .landscapeLeft
        app.launch()
        disableNotifications(for: app)
        app.assertStaticTextExists("Charity run")
        app.staticTexts["Charity run"].tap()

        // When user tap on share button
        let shareButton = app.buttons["Share"]
        shareButton.assertExists()
        shareButton.tap()

        // Then share sheet is presented
        if #available(iOS 17.0, *) {
            app.otherElements["ShareSheet.RemoteContainerView"].assertExists()
        } else {
            app.otherElements["ActivityListView"].assertExists()
        }
    }

    func test_OpenEvent() {
        // Given user open an event from share
        XCUIDevice.shared.orientation = .portrait
        app.launch()
        disableNotifications(for: app)
        SafariUrlOpener.shared.open(url: "eventorias://event/1")

        // When app become active
        _ = app.wait(for: .runningForeground, timeout: 5)

        // Then the share event is presented
        app.buttons["Share"].assertExists()
        app.assertStaticTextExists("Charity run")

        // And when user open an other share
        SafariUrlOpener.shared.open(url: "eventorias://event/2")

        // Then the other share is presented
        app.buttons["Share"].assertExists()
        app.assertStaticTextExists("Book signing")
    }
}


final class SafariUrlOpener {

    // Singleton instance
    static let shared = SafariUrlOpener()
    private init() {}

    // Safari app by its identifier
    private let safari: XCUIApplication = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

    /// Opens safari with given url
    /// - Parameter url: URL of the deeplink.
    func open(url: String) {
        if safari.state != .notRunning {
            // Safari can get in to bugs depending on too many tests.
            // Better to kill at the beginning.
            safari.terminate()
            _ = safari.wait(for: .notRunning, timeout: 5)
        }

        safari.launch()

        // Ensure that safari is running
        _ = safari.wait(for: .runningForeground, timeout: 30)

        // Access the search bar of the safari
        let searchBar = safari.descendants(matching: .any).matching(identifier: "Adresse").firstMatch
        searchBar.tap()

        // Enter the URL
        safari.typeText(url)

        // Simulate "Return" key tap
        safari.typeText("\n")

        // Tap "Open" on confirmation dialog
        safari.buttons["Ouvrir"].tap()
    }
}
