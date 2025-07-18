//
//  FirebaseNotifRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 13/06/2025.
//

import Foundation
import SwiftUI

class FirebaseNotifRepository: NotificationsRepository {

    private let appNotifStatusKey: String = "appNotifStatus"
    var granted: Bool

    init() {
        granted = UserDefaults.standard.bool(forKey: appNotifStatusKey)
    }

    func enableNotifications() async {
        guard !granted else { return }
        UserDefaults.standard.set(true, forKey: appNotifStatusKey)
        updateGrantedStatus()
    }
    
    func disableNotifications() async {
        guard granted else { return }
        UserDefaults.standard.set(false, forKey: appNotifStatusKey)
        updateGrantedStatus()
    }

    func userNotificationCenterStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }
}

extension FirebaseNotifRepository {

    private func updateGrantedStatus() {
        granted = UserDefaults.standard.bool(forKey: appNotifStatusKey)
    }
}
