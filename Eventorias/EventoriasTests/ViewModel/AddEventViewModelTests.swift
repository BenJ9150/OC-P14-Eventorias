//
//  AddEventViewModelTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 30/05/2025.
//

import XCTest
@testable import Eventorias

@MainActor final class AddEventViewModelTests: XCTestCase {
    
    // MARK: Add event Success
    
    func test_AddEventSuccess() async {
        // Given valid data
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(),
            categories: MockData().eventCategories()
        )
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "Test Address"
        viewModel.addEventDate = Date()
        viewModel.addEventPhoto = UIImage()
        viewModel.addEventCategory = MockData().eventCategory()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a success
        XCTAssertTrue(success)
    }
}

// MARK: Add event failures

extension AddEventViewModelTests {

    func test_AddEventEmptyFields() async {
        // Given empty fields
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(),
            categories: MockData().eventCategories()
        )

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
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(),
            categories: MockData().eventCategories()
        )
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "1 Apple Park Way, Cupertino, CA"
        viewModel.addEventPhoto = MockData().image()
        viewModel.addEventCategory = MockData().eventCategory()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure and error messages
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventDateErr, AppError.emptyField.userMessage)
        XCTAssertEqual(viewModel.addEventTimeErr, AppError.emptyField.userMessage)
    }

    func test_AddEventFailureCauseUser() async {
        // Given no user
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(),
            categories: MockData().eventCategories()
        )
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "1 Apple Park Way, Cupertino, CA"
        viewModel.addEventDate = Date()
        viewModel.addEventPhoto = MockData().image()
        viewModel.addEventCategory = MockData().eventCategory()

        // When add event
        let success = await viewModel.addEvent(byUser: nil)

        // Then there is a failure and error messages
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventError, AppError.currentUserNotFound.userMessage)
    }

    func test_AddEventFailureCauseAddress() async {
        // Given invalid address
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(),
            categories: MockData().eventCategories()
        )
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "address"
        viewModel.addEventDate = Date()
        viewModel.addEventPhoto = MockData().image()
        viewModel.addEventCategory = MockData().eventCategory()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure and error messages
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventAddressErr, AppError.invalidAddress.userMessage)
    }

    func test_AddEventFailureCauseCategory() async {
        // Given no category
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(),
            categories: MockData().eventCategories()
        )
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "1 Apple Park Way, Cupertino, CA"
        viewModel.addEventDate = Date()
        viewModel.addEventPhoto = MockData().image()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure with network error
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventCategoryErr, AppError.emptyField.userMessage)
    }

    func test_AddEventFailureCausePhoto() async {
        // Given no photo
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(),
            categories: MockData().eventCategories()
        )
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "1 Apple Park Way, Cupertino, CA"
        viewModel.addEventDate = Date()
        viewModel.addEventCategory = MockData().eventCategory()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure with network error
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventError, AppError.emptyImage.userMessage)
    }

    func test_AddEventFailureCauseNetwork() async {
        // Given network error
        let viewModel = AddEventViewModel(
            eventRepo: MockEventRepository(withNetworkError: true),
            categories: MockData().eventCategories()
        )
        viewModel.addEventTitle = "Test Event"
        viewModel.addEventDesc = "Test Desc"
        viewModel.addEventAddress = "1 Apple Park Way, Cupertino, CA"
        viewModel.addEventDate = Date()
        viewModel.addEventPhoto = MockData().image()
        viewModel.addEventCategory = MockData().eventCategory()

        // When add event
        let success = await viewModel.addEvent(byUser: MockUser())

        // Then there is a failure with network error
        XCTAssertFalse(success)
        XCTAssertEqual(viewModel.addEventError, AppError.networkError.userMessage)
    }
}
