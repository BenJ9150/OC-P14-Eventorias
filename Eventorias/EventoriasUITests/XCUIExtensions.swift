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
        XCTAssertTrue(element.waitForExistence(timeout: 2), "\"\(label)\" doesn't exist")
    }

    func assertStaticTextExistsAtPosition(_ label: String) -> CGFloat {
        let element = staticTexts[label]
        XCTAssertTrue(element.waitForExistence(timeout: 2), "\"\(label)\" doesn't exist")
        return element.frame.origin.y
    }

    func assertStaticTextDisappears(_ label: String) {
        let element = staticTexts[label]
        XCTAssertTrue(element.waitForNonExistence(timeout: 2), "\"\(label)\" did not disappear")
    }

    func assertStaticTextsCount(_ matching: String, count: Int) {
        let texts = staticTexts.matching(identifier: matching)
        _ = texts.firstMatch.waitForExistence(timeout: 1)
        XCTAssertEqual(texts.count, count)
    }

    func assertMainViewIsVisible() {
        XCTAssertTrue(textFields["Search"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["List"].waitForExistence(timeout: 2))
    }

    func assertSignInViewIsVisible() {
        XCTAssertTrue(buttons["Sign in with email"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["GoToSignUp"].waitForExistence(timeout: 2))
    }

    func forceUIStabilization() {
        if #available(iOS 17, *) {
            /// No need to do that...
        } else {
            let dummyCoord = self.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.01))
            dummyCoord.tap()
        }
    }

    func tapCustomButtons(_ name: String) {
        if #available(iOS 17.0, *) {
            buttons[name].tap()
        } else {
            /// Search localisation and tap
            let x = buttons[name].frame.midX
            let y = buttons[name].frame.midY
            let normalizedOffset = CGVector(dx: x / frame.width, dy: y / frame.height)
            coordinate(withNormalizedOffset: normalizedOffset).tap()
        }
    }
}

// MARK: XCUIElement

extension XCUIElement {

    func assertExists(withButtons buttons: [String] = [], timeout: TimeInterval = 2) {
        XCTAssertTrue(self.waitForExistence(timeout: timeout))
        for button in buttons {
            XCTAssertTrue(self.buttons[button].exists)
        }
    }

    func assertNotExists() {
        XCTAssertFalse(self.waitForExistence(timeout: 2))
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
