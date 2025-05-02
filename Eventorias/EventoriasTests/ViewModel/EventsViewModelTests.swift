//
//  EventsViewModelTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import XCTest
@testable import Eventorias

@MainActor final class EventsViewModelTests: XCTestCase {

    // MARK: Fetch data

    func test_FetchDataSuccess() async {
        // Given
        let eventService = EventService(dbRepo: MockDatabaseRepository())
        let viewModel = EventsViewModel(eventService: eventService)

        // When fetch data
        await viewModel.fetchData()

        // Then there are events and categories with no error
        XCTAssertTrue(viewModel.events.count > 0)
        XCTAssertTrue(viewModel.categories.count > 0)
        XCTAssertTrue(viewModel.fetchEventsError.isEmpty)
        XCTAssertFalse(viewModel.fetchingEvents)
    }

    func test_FetchDataFailure() async {
        // Given network error
        let databaseRepo = MockDatabaseRepository(withNetworkError: true)
        let viewModel = EventsViewModel(eventService: EventService(dbRepo: databaseRepo))

        // When fetch data
        await viewModel.fetchData()

        // Then there is an error
        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertTrue(viewModel.categories.isEmpty)
        XCTAssertEqual(viewModel.fetchEventsError, AppError.networkError.userMessage)
        XCTAssertFalse(viewModel.fetchingEvents)
    }
}
