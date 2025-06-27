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

// MARK: Show event from URL

extension EventsViewModelTests {

    func test_ShowEventFromUrlSuccess() async {
        // Given
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        let eventToShow = MockData().event()
        let url = eventToShow.shareURL!

        // When show event
        await viewModel.showEvent(from: url)
        
        // Then event is presented
        XCTAssertEqual(eventToShow.title, viewModel.eventFromShare!.title)
    }

    func test_ShowEventFromUrlfailure() async {
        // Given wrong url
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        let url = URL(string: "www.test.com")!

        // When show event
        await viewModel.showEvent(from: url)
        
        // Then event is not presented
        XCTAssertNil(viewModel.eventFromShare)
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

// MARK: Participants

extension EventsViewModelTests {

    func test_UserParticipateAtTheEvent() {
        // Given user is on the participants list
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        let user = MockData().user()
        let event = MockData().event(participant: user.uid)

        // When check if user is a participant
        viewModel.setParticipation(to: event, user: user)

        // Then user is a participant
        XCTAssertTrue(viewModel.toggleParticipate)
    }

    func test_UserNotParticipateAtTheEvent() {
        // Given user is not on the participants list
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        let user = MockData().user()
        let event = MockData().event()

        // When check if user is a participant
        viewModel.setParticipation(to: event, user: user)

        // Then user is not a participant
        XCTAssertFalse(viewModel.toggleParticipate)
    }

    func test_UserWantsToParticipateSuccess() async {
        // Given user is not on the participants list
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        let user = MockData().user()
        let event = MockData().event()

        // When user wants to participate
        await viewModel.toggleParticipation(to: true, event: event, user: user)

        // Then user is a participant and no error is thrown
        XCTAssertTrue(viewModel.toggleParticipate)
        XCTAssertTrue(viewModel.toggleParticipateError.isEmpty)
    }

    func test_UserNoLongerWantsToParticipateSuccess() async {
        // Given user is on the participants list
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        let user = MockData().user()
        let event = MockData().event(participant: user.uid)

        // When user no longer wants to participate
        await viewModel.toggleParticipation(to: false, event: event, user: user)

        // Then user is not a participant and no error is thrown
        XCTAssertFalse(viewModel.toggleParticipate)
        XCTAssertTrue(viewModel.toggleParticipateError.isEmpty)
    }

    func test_UserWantsToParticipateFailure() async {
        // Given user is not on the participants list and network error
        let eventRepo = MockEventRepository(withNetworkError: true)
        let viewModel = EventsViewModel(eventRepo: eventRepo)
        let user = MockData().user()
        let event = MockData().event()

        // When user wants to participate
        await viewModel.toggleParticipation(to: true, event: event, user: user)

        // Then user is still not on the list and error is thrown
        XCTAssertFalse(viewModel.toggleParticipate)
        XCTAssertEqual(viewModel.toggleParticipateError, AppError.networkError.userMessage)
    }
}
