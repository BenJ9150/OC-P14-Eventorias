//
//  AddEventUITests.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 04/07/2025.
//

import XCTest

final class AddEventUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
        disableNotifications(for: app)
        app.buttons["Add an event"].tap()
        app.assertStaticTextExists("Creation of an event")
    }

    func test_AddEvent() {
        // Given user tap on validate button, there are 6 empty field errors
        app.buttons["Validate"].tap()
        app.assertStaticTextsCount("This field is required.", count: 6)

        // When user complete text fiels
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Title")
        app.keyboards.buttons["suivant"].tap()
        app.textFields["Description"].typeText("Description")
        app.keyboards.buttons["suivant"].tap()
        app.textFields["Address"].typeText("Test address")
        app.keyboards.buttons["retour"].tap()

        // Choose time
        app.tapCustomButtons("TimePicker")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "21")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.1)).tap()

        // Choose category
        app.tapCustomButtons("CategoryPicker")
        app.buttons["Art & Exhibitions"].tap()

        // Choose picture
        app.buttons["Choose a photo"].tap()
        app.buttons["Photos"].assertExists(timeout: 10) /// Button of photoPicker
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.4)).tap()
        app.buttons["Remove photo"].assertExists()

        // And tap on validate button
        app.buttons["Validate"].tap()

        // Then sheet is closed
        app.assertMainViewIsVisible()
    }
}
