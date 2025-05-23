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

    // MARK: Add event

    func test_AddEventSuccess() async {
        // Given valid data
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "Test Address"
        viewModel.addEventDate = Date()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a success
        XCTAssertTrue(success)
    }

    func test_AddEventEmptyFields() async {
        // Given empty fields
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        viewModel.addEventDate = Date()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure and error messages
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventTitleErr, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.addEventDescErr, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.addEventAddressErr, AppError.emptyField.userMessage)
    }

    func test_AddEventFailureCauseDate() async {
        // Given no date
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "Test Address"

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure and error messages
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventDateErr, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.addEventTimeErr, AppError.emptyField.userMessage)
    }

    func test_AddEventFailureCauseUser() async {
        // Given no user
        let viewModel = EventsViewModel(eventRepo: MockEventRepository())
        let user: MockUser? = nil

        // When add event
        let success = await viewModel.addEvent(byUser: user)

        // Then there is a failure and error messages
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventError, AppError.currentUserNotFound.userMessage)
    }

    func test_AddEventFailureCauseNetwork() async {
        // Given network error
        let eventRepo = MockEventRepository(withNetworkError: true)
        let viewModel = EventsViewModel(eventRepo: eventRepo)
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "Test Address"
        viewModel.addEventDate = Date()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure with network error
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventError, AppError.networkError.userMessage)
    }
}
