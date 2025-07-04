//
//  MainEventViewTests.swift
//  EventoriasUITests
//
//  Created by Benjamin LEFRANCOIS on 04/07/2025.
//

import XCTest

// MARK: Search

final class SearchUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
        app.assertStaticTextExists("Charity run")
    }

    func test_SearchEvent() throws {
        // Given user search an event
        app.textFields["Search"].tap()
        app.textFields["Search"].typeText("Art exhibition")
    
        // When user tap on search button
        app.keyboards.buttons["rechercher"].tap()

        // Then one event is founded
        app.assertStaticTextExists("1 event found")
        app.assertStaticTextExists("Art exhibition")
        app.assertStaticTextDisappears("Charity run")

        // And when clear search
        app.buttons["ClearSearchButton"].tap()

        // Then other events re-appear
        app.assertStaticTextExists("Charity run")
    }
}

// MARK: Sort

final class SortUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
        app.assertStaticTextExists("Charity run")
    }

    func test_SortByCategory() throws {
        // Given user tap on category filter
        app.buttons["Category"].tap()
    
        // And choose categories
        app.staticTexts["Art & Exhibitions"].tap()
        app.staticTexts["Charity & Volunteering"].tap()

        // When close categories picker view
        app.buttons["Close"].tap()

        // Then two events are founded
        app.assertStaticTextExists("Art exhibition")
        app.assertStaticTextExists("Charity run")

        // And when remove one category
        app.staticTexts["Charity & Volunteering"].tap()
    
        // Then result of this category is removed
        app.assertStaticTextDisappears("Charity run")
    }

    func test_SortByDate() throws {
        // Given user tap on sort button
        app.buttons["Sorting by title"].tap()
    
        // And choose "Sorting by date"
        app.buttons["Sorting by date"].tap()

        // Then "Charity run" is before "Art exhibition"
        XCTAssertLessThan(
            app.assertStaticTextExistsAtPosition("Charity run"),
            app.assertStaticTextExistsAtPosition("Art exhibition")
        )

        // And when user choose "Sorting by title"
        app.buttons["Sorting by date"].tap()
        app.buttons["Sorting by title"].tap()

        // Then "Art exhibition" is before "Charity run"
        XCTAssertLessThan(
            app.assertStaticTextExistsAtPosition("Art exhibition"),
            app.assertStaticTextExistsAtPosition("Charity run")
        )
    }
}

// MARK: Show calendar

final class ShowCalendarUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(AppFlags.uiTesting)
        app.launch()
        app.assertStaticTextExists("Charity run")
    }

    func test_ShowCalendar() throws {
        // Given is on list view
        app.buttons["List"].tap()
    
        // When user tap on calendar button
        app.buttons["Calendar"].tap()

        // Then calendar is presented
        app.otherElements["CalendarView"].assertExists()
    }
}
