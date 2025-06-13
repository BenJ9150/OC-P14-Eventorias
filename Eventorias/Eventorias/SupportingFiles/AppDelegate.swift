//
//  AppDelegate.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        registerForPushNotifications()
        return true
    }

    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error when request push notifications authorization: \(error)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Push notifications: authorization denied")
            }
        }
    }
}
