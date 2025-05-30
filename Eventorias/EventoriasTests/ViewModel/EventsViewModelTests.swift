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
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        
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
        let eventRepo = MockEventRepository(withNetworkError: true)
        let viewModel = EventsViewModel(eventRepo: eventRepo)
        
        // When fetch data
        await viewModel.fetchData()
        
        // Then there is an error
        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertTrue(viewModel.categories.isEmpty)
        XCTAssertEqual(viewModel.fetchEventsError, AppError.networkError.userMessage)
        XCTAssertFalse(viewModel.fetchingEvents)
    }
}

// MARK: Search

extension EventsViewModelTests {

    func test_SearchSuccessAndClean() async {
        // Given
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        viewModel.search = "Run"

        // When search
        await viewModel.searchEvents()

        // Then there is one event found with no error
        XCTAssertEqual(viewModel.searchResult[0].title, "Charity run")
        XCTAssertTrue(viewModel.searchEventsError.isEmpty)
        XCTAssertTrue(viewModel.userIsSearching)

        // And when clear
        viewModel.clearSearch()

        // Then all data are cleaned
        XCTAssertFalse(viewModel.userIsSearching)
        XCTAssertFalse(viewModel.fetchingSearchedEvents)
        XCTAssertTrue(viewModel.search.isEmpty)
        XCTAssertTrue(viewModel.searchResult.isEmpty)
        XCTAssertTrue(viewModel.searchEventsError.isEmpty)
    }

    func test_SearchEmptyPrompt() async {
        // Given no search
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        viewModel.search = ""

        // When search
        await viewModel.searchEvents()

        // Then user is not searching event
        XCTAssertFalse(viewModel.userIsSearching)
        XCTAssertTrue(viewModel.searchEventsError.isEmpty)
    }

    func test_SearchEmptyResult() async {
        // Given
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        viewModel.search = "abcdef"

        // When search
        await viewModel.searchEvents()

        // Then error is empty result
        XCTAssertEqual(viewModel.searchEventsError, AppError.searchEventIsEmpty.userMessage)
    }

    func test_SearchFailure() async {
        // Given network error
        let eventRepo = MockEventRepository(withNetworkError: true)
        let viewModel = EventsViewModel(eventRepo: eventRepo)
        viewModel.search = "Run"

        // When search
        await viewModel.searchEvents()

        // Then there is an error
        XCTAssertEqual(viewModel.searchEventsError, AppError.networkError.userMessage)
    }
}
