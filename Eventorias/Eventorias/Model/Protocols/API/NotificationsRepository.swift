//
//  NotificationsRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 13/06/2025.
//

import Foundation
import SwiftUI

protocol NotificationsRepository {

    var granted: Bool { get }
    func enableNotifications() async
    func disableNotifications() async
    func userNotificationCenterStatus() async -> UNAuthorizationStatus
}
