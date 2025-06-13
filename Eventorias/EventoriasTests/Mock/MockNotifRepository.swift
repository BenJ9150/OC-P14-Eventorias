//
//  MockNotifRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 13/06/2025.
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockNotifRepository: NotificationsRepository {

    var granted: Bool
    var grantedOnCenter: Bool

    init(grantedOnCenter: Bool, grantedOnRepo: Bool) {
        self.granted = grantedOnRepo
        self.grantedOnCenter = grantedOnCenter
    }

    func enableNotifications() async {
        guard !granted else { return }
        granted = true
    }

    func disableNotifications() async {
        guard granted else { return }
        granted = false
    }

    func userNotificationCenterStatus() async -> UNAuthorizationStatus {
        return grantedOnCenter ? .authorized : .denied
    }
}

extension MockNotifRepository {

    func disableNotificationsFromSettings() {
        grantedOnCenter = false
    }
}
