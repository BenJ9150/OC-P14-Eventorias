//
//  NotificationsViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 13/06/2025.
//

import SwiftUI

@MainActor class NotificationsViewModel: ObservableObject {

    @Published private(set) var toggleNotifications = false
    @Published var showPermissionAlert = false

    let notifRepo: NotificationsRepository

    init(notifRepo: NotificationsRepository = FirebaseNotifRepository()) {
        self.notifRepo = notifRepo
    }
}

extension NotificationsViewModel {

    func updateStatus() async {
        /// Check user notifications center settings
        let status = await notifRepo.userNotificationCenterStatus()
        guard status == .authorized || status == .provisional else {
            /// User notifications for app not accepted
            toggleNotifications = false
            await notifRepo.disableNotifications()
            return
        }
        /// Update toggle status
        toggleNotifications = notifRepo.granted
    }

    func toggle(to value: Bool) async {
        toggleNotifications = value
        let status = await notifRepo.userNotificationCenterStatus()
        
        if toggleNotifications {
            /// User just enable notifications
            if status == .authorized || status == .provisional {
                await notifRepo.enableNotifications()
            } else {
                /// But user haven't accepted notifications in the settings of the app
                showPermissionAlert = true
                toggleNotifications = false
            }
        } else {
            /// User just disable notifications
            await notifRepo.disableNotifications()
        }
    }
}
