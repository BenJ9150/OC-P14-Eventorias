//
//  NotificationsViewModelTests.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 13/06/2025.
//

import XCTest
@testable import Eventorias

@MainActor final class NotificationsViewModelTests: XCTestCase {

    func test_GivenNotifCenterAreGranted_WhenEnableNotif_ThenNotifAreON() async {
        // Given
        let notifRepo = MockNotifRepository(grantedOnCenter: true, grantedOnRepo: false)
        let viewModel = NotificationsViewModel(notifRepo: notifRepo)
        await viewModel.updateStatus()

        // When
        await viewModel.toggle(to: true)

        // Then
        XCTAssertTrue(viewModel.toggleNotifications)
    }

    func test_GivenNotifCenterAreDenied_WhenEnableNotif_ThenAlertIsPresented() async {
        // Given
        let notifRepo = MockNotifRepository(grantedOnCenter: false, grantedOnRepo: false)
        let viewModel = NotificationsViewModel(notifRepo: notifRepo)
        await viewModel.updateStatus()

        // When
        await viewModel.toggle(to: true)

        // Then
        XCTAssertTrue(viewModel.showPermissionAlert)
        XCTAssertFalse(viewModel.toggleNotifications)
    }

    func test_GivenRepoNotifAreGranted_WhenDisableNotifFromSettings_ThenNotifAreOff() async {
        // Given
        let notifRepo = MockNotifRepository(grantedOnCenter: true, grantedOnRepo: true)
        let viewModel = NotificationsViewModel(notifRepo: notifRepo)
        await viewModel.updateStatus()
        XCTAssertTrue(viewModel.toggleNotifications)

        // When
        notifRepo.disableNotificationsFromSettings()
        await viewModel.updateStatus()

        // Then
        XCTAssertFalse(viewModel.toggleNotifications)
    }

    func test_GivenRepoNotifAreGranted_WhenDisableNotif_ThenNotifAreOff() async {
        // Given
        let notifRepo = MockNotifRepository(grantedOnCenter: true, grantedOnRepo: true)
        let viewModel = NotificationsViewModel(notifRepo: notifRepo)
        await viewModel.updateStatus()
        XCTAssertTrue(viewModel.toggleNotifications)

        // When
        await viewModel.toggle(to: false)

        // Then
        XCTAssertFalse(viewModel.toggleNotifications)
    }
}
