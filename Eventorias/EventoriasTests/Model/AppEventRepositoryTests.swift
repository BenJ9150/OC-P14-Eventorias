//
//  EventServiceTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import XCTest
@testable import Eventorias

final class AppEventRepositoryTests: XCTestCase {
    
    // MARK: Fetch event
    
    func test_FetchEventSuccess() async {
        // Given
        let eventRepo = AppEventRepository(
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        // When fetch event
        let event = try! await eventRepo.fetchEvent(withId: "testId")
        
        // Then event exist
        XCTAssertEqual(event!.title, "Charity run")
    }
}

// MARK: Fetch events

extension AppEventRepositoryTests {

    func test_FetchEventsSuccess() async {
        // Given
        let eventRepo = AppEventRepository(
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        let categories = MockData().eventCategories()

        // When fetch events
        let events = try! await eventRepo.fetchEvents(orderBy: .byTitle, from: categories)

        // Then an event exist
        XCTAssertEqual(events[0].title, "Charity run")
    }

    func test_FetchEventsFailure() async {
        // Given invalid data
        let dbRepo = MockDatabaseRepository(withDecodingError: true)
        let storageRepo = MockStorageRepository()
        let eventRepo = AppEventRepository(dbRepo: dbRepo, storageRepo: storageRepo)

        // When fetch events
        let events = try! await eventRepo.fetchEvents(orderBy: .byTitle, from: [])

        // Then there is no event
        XCTAssertTrue(events.isEmpty)
    }
}

// MARK: Fetch categories

extension AppEventRepositoryTests {

    func test_FetchCategoriesSuccess() async {
        // Given
        let eventRepo = AppEventRepository(
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        // When fetch event categories
        let categories = try! await eventRepo.fetchCategories()

        // Then a category exist
        XCTAssertEqual(categories[0].name, "Art & Exhibitions")
    }

    func test_FetchCategoriesFailure() async {
        // Given invalid data
        let eventRepo = AppEventRepository(
            dbRepo: MockDatabaseRepository(withDecodingError: true),
            storageRepo: MockStorageRepository()
        )
        // When fetch event categories
        let categories = try! await eventRepo.fetchCategories()

        // Then there is no event category
        XCTAssertTrue(categories.isEmpty)
    }
}

// MARK: Add event

extension AppEventRepositoryTests {

    func test_AddEventSuccess() async {
        // Given
        let eventRepo = AppEventRepository(
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
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
        let eventRepo = AppEventRepository(
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
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
}

// MARK: Search

extension AppEventRepositoryTests {

    func test_FetchSearchSuccess() async {
        // Given
        let eventRepo = AppEventRepository(
            dbRepo: MockDatabaseRepository(),
            storageRepo: MockStorageRepository()
        )
        // When search event
        let events = try! await eventRepo.searchEvents(with: "Run")

        // Then an event is found
        XCTAssertEqual(events[0].title, "Charity run")
    }
}
