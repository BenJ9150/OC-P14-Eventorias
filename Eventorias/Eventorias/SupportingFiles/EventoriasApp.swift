//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

@main
struct EventoriasApp: App {

    @Environment(\.scenePhase) var scenePhase
    @StateObject private var authViewModel = AuthViewModel()

    /// Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if authViewModel.currentUser == nil {
                SignInView()
            } else {
                ContentView()
            }
        }
        .environmentObject(authViewModel)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                authViewModel.refreshCurrentUser()
            }
        }
    }
}
