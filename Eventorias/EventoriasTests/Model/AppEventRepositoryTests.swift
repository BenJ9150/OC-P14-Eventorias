//
//  EventServiceTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import XCTest
@testable import Eventorias

final class AppEventRepositoryTests: XCTestCase {

    // MARK: Fetch events

    func test_FetchEventsSuccess() async {
        // Given
        let eventService = AppEventRepository(dbRepo: MockDatabaseRepository())

        // When fetch events
        let events = try! await eventService.fetchEvents()

        // Then a category exist
        XCTAssertEqual(events[0].title, "Charity run")
    }

    func test_FetchEventsFailure() async {
        // Given invalid data
        let databaseRepo = MockDatabaseRepository(withDecodingError: true)
        let eventService = AppEventRepository(dbRepo: databaseRepo)

        // When fetch events
        let events = try! await eventService.fetchEvents()

        // Then there is no event
        XCTAssertTrue(events.isEmpty)
    }

    // MARK: Fetch categories

    func test_FetchCategoriesSuccess() async {
        // Given
        let eventService = AppEventRepository(dbRepo: MockDatabaseRepository())

        // When fetch event categories
        let categories = try! await eventService.fetchCategories()

        // Then a category exist
        XCTAssertEqual(categories[0].name, "Art & Exhibitions")
    }

    func test_FetchCategoriesFailure() async {
        // Given invalid data
        let databaseRepo = MockDatabaseRepository(withDecodingError: true)
        let eventService = AppEventRepository(dbRepo: databaseRepo)

        // When fetch event categories
        let categories = try! await eventService.fetchCategories()

        // Then there is no event category
        XCTAssertTrue(categories.isEmpty)
    }

    // MARK: Add event

    func test_AddEventSuccess() async {
        // Given
        let eventService = AppEventRepository(dbRepo: MockDatabaseRepository())

        // When add event
        do {
            try await eventService.addEvent(MockEvent().event())
            // Then no error is throw
        } catch {
            XCTFail("test_AddEventSuccess error")
        }
    }
}
