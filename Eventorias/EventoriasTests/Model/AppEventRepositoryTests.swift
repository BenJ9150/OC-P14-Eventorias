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
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventService = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch events
        let events = try! await eventService.fetchEvents()

        // Then a category exist
        XCTAssertEqual(events[0].title, "Charity run")
    }

    func test_FetchEventsFailure() async {
        // Given invalid data
        let dbRepo = MockDatabaseRepository(withDecodingError: true)
        let storageRepo = MockStorageRepository()
        let eventService = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch events
        let events = try! await eventService.fetchEvents()

        // Then there is no event
        XCTAssertTrue(events.isEmpty)
    }

    // MARK: Fetch categories

    func test_FetchCategoriesSuccess() async {
        // Given
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventService = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch event categories
        let categories = try! await eventService.fetchCategories()

        // Then a category exist
        XCTAssertEqual(categories[0].name, "Art & Exhibitions")
    }

    func test_FetchCategoriesFailure() async {
        // Given invalid data
        let dbRepo = MockDatabaseRepository(withDecodingError: true)
        let storageRepo = MockStorageRepository()
        let eventService = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch event categories
        let categories = try! await eventService.fetchCategories()

        // Then there is no event category
        XCTAssertTrue(categories.isEmpty)
    }

    // MARK: Add event

    func test_AddEventSuccess() async {
        // Given
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventService = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)
        let event = MockData().event()
        let image = MockData().image()

        // When add event
        do {
            try await eventService.addEvent(event, image: image)
            // Then no error is throw
        } catch {
            XCTFail("test_AddEventSuccess error: \(error.localizedDescription)")
        }
    }

    func test_AddEventFailure() async {
        // Given invalid image
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventService = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)
        let event = MockData().event()
        let image = UIImage()

        // When add event
        do {
            try await eventService.addEvent(event, image: image)
        } catch {
            // There is an error
            let appError = error as! AppError
            XCTAssertEqual(appError.userMessage, AppError.invalidImage.userMessage)
        }
    }
}
