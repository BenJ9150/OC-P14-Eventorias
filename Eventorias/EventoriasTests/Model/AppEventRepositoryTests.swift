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
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch events
        let events = try! await eventRepo.fetchEvents(orderBy: .byTitle)

        // Then an event exist
        XCTAssertEqual(events[0].title, "Charity run")
    }

    func test_FetchEventsFailure() async {
        // Given invalid data
        let dbRepo = MockDatabaseRepository(withDecodingError: true)
        let storageRepo = MockStorageRepository()
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch events
        let events = try! await eventRepo.fetchEvents(orderBy: .byTitle)

        // Then there is no event
        XCTAssertTrue(events.isEmpty)
    }

    // MARK: Fetch categories

    func test_FetchCategoriesSuccess() async {
        // Given
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch event categories
        let categories = try! await eventRepo.fetchCategories()

        // Then a category exist
        XCTAssertEqual(categories[0].name, "Art & Exhibitions")
    }

    func test_FetchCategoriesFailure() async {
        // Given invalid data
        let dbRepo = MockDatabaseRepository(withDecodingError: true)
        let storageRepo = MockStorageRepository()
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch event categories
        let categories = try! await eventRepo.fetchCategories()

        // Then there is no event category
        XCTAssertTrue(categories.isEmpty)
    }

    // MARK: Add event

    func test_AddEventSuccess() async {
        // Given
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)
        let event = MockData().event()
        let image = MockData().image()

        // When add event
        do {
            try await eventRepo.addEvent(event, image: image)
            // Then no error is throw
        } catch {
            XCTFail("test_AddEventSuccess error: \(error.localizedDescription)")
        }
    }

    func test_AddEventFailure() async {
        // Given invalid image
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)
        let event = MockData().event()
        let image = UIImage()

        // When add event
        do {
            try await eventRepo.addEvent(event, image: image)
        } catch {
            // There is an error
            let appError = error as! AppError
            XCTAssertEqual(appError.userMessage, AppError.invalidImage.userMessage)
        }
    }

    // MARK: Search

    func test_FetchSearchSuccess() async {
        // Given
        let dbRepo = MockDatabaseRepository()
        let storageRepo = MockStorageRepository()
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When search event
        let events = try! await eventRepo.searchEvents(with: "Run")

        // Then an event is found
        XCTAssertEqual(events[0].title, "Charity run")
    }
}
