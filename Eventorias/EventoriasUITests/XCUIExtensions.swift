//
//  XCUIExtensions.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 04/07/2025.
//

import XCTest

// MARK: XCUIApplication

extension XCUIApplication {

    func assertStaticTextExists(_ label: String) {
        let element = staticTexts[label]
        XCTAssertTrue(element.waitForExistence(timeout: 1), "\"\(label)\" doesn't exist")
    }

    func assertStaticTextExistsAtPosition(_ label: String) -> CGFloat {
        let element = staticTexts[label]
        XCTAssertTrue(element.waitForExistence(timeout: 1), "\"\(label)\" doesn't exist")
        return element.frame.origin.y
    }

    func assertStaticTextDisappears(_ label: String) {
        let element = staticTexts[label]
        XCTAssertTrue(element.waitForNonExistence(timeout: 1), "\"\(label)\" did not disappear")
    }

    func assertStaticTextsCount(_ matching: String, count: Int) {
        let texts = staticTexts.matching(identifier: matching)
        _ = texts.firstMatch.waitForExistence(timeout: 1)
        XCTAssertEqual(texts.count, count)
    }

    func assertMainViewIsVisible() {
        XCTAssertTrue(textFields["Search"].waitForExistence(timeout: 1))
        XCTAssertTrue(buttons["List"].waitForExistence(timeout: 1))
    }

    func assertSignInViewIsVisible() {
        XCTAssertTrue(buttons["Sign in with email"].waitForExistence(timeout: 1))
        XCTAssertTrue(buttons["GoToSignUp"].waitForExistence(timeout: 1))
    }
}

// MARK: XCUIElement

extension XCUIElement {

    func assertExists(withButtons buttons: [String] = []) {
        XCTAssertTrue(self.waitForExistence(timeout: 1))
        for button in buttons {
            XCTAssertTrue(self.buttons[button].exists)
        }
    }

    func assertNotExists() {
        XCTAssertFalse(self.waitForExistence(timeout: 1))
    }

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
