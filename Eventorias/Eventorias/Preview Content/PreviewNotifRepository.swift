//
//  PreviewNotifRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 29/06/2025.
//

import Foundation
import SwiftUI

class PreviewNotifRepository: NotificationsRepository {
    var granted: Bool

    init(granted: Bool = false) {
        self.granted = granted
    }

    func enableNotifications() async {}
    
    func disableNotifications() async {}
    
    func userNotificationCenterStatus() async -> UNAuthorizationStatus {
        return .denied
    }
}
