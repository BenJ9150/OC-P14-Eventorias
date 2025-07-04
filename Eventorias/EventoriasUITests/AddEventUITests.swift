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
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
    }

    func test_AddEventEmptyField() {
        // Given user is on add event view
        app.buttons["Add an event"].tap()

        // When user tap on validate button
        app.buttons["Validate"].tap()

        // Then 6 textfields are required
        app.assertStaticTextsCount("This field is required.", count: 6)
    }

    func test_AddEventSuccess() {
        // Given user complete text fiels
        app.buttons["Add an event"].tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Title")
        app.keyboards.buttons["suivant"].tap()
        app.textFields["Description"].typeText("Description")
        app.keyboards.buttons["suivant"].tap()
        app.textFields["Address"].typeText("Test address")
        app.keyboards.buttons["retour"].tap()

        // Choose time
        app.buttons["TimePicker"].tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "21")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1)).tap()

        // Choose category
        app.buttons["CategoryPicker"].tap()
        app.buttons["Art & Exhibitions"].tap()

        // And choose picture
        app.buttons["Choose a photo"].tap()
        /// Wait that photos of photoPicker are loaded (Cancel button appear when photos are loaded)
        app.buttons["Annuler"].assertExists(timeout: 10)
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.7)).tap()
        
        // When user tap on validate button
        app.buttons["Validate"].tap()

        // Then sheet is closed
        app.assertMainViewIsVisible()
    }
}
