//
//  EventServiceTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import XCTest
@testable import Eventorias

final class EventServiceTests: XCTestCase {

    // MARK: Events

    func test_FetchEventsSuccess() async {
        // Given
        let eventService = EventService(dbRepo: MockDatabaseRepository())

        // When fetch events
        let events = try! await eventService.fetchEvents()

        // Then a category exist
        XCTAssertEqual(events[0].title, "Charity run")
    }

    func test_FetchEventsFailure() async {
        // Given invalid data
        let databaseRepo = MockDatabaseRepository(withDecodingError: true)
        let eventService = EventService(dbRepo: databaseRepo)

        // When fetch events
        let events = try! await eventService.fetchEvents()

        // Then there is no event
        XCTAssertTrue(events.isEmpty)
    }

    // MARK: Categories

    func test_FetchCategoriesSuccess() async {
        // Given
        let eventService = EventService(dbRepo: MockDatabaseRepository())

        // When fetch event categories
        let categories = try! await eventService.fetchEventCategories()

        // Then a category exist
        XCTAssertEqual(categories[0].name, "Art & Exhibitions")
    }

    func test_FetchCategoriesFailure() async {
        // Given invalid data
        let databaseRepo = MockDatabaseRepository(withDecodingError: true)
        let eventService = EventService(dbRepo: databaseRepo)

        // When fetch event categories
        let categories = try! await eventService.fetchEventCategories()

        // Then there is no event category
        XCTAssertTrue(categories.isEmpty)
    }
}
