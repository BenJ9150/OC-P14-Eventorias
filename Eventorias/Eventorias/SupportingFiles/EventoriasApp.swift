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
    @StateObject private var eventsViewModel = EventsViewModel()

    /// Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if authViewModel.currentUser == nil {
                SignInView()
            } else {
                CustomTabView(eventsViewModel: eventsViewModel)
            }
        }
        .environmentObject(authViewModel)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                authViewModel.refreshCurrentUser()
                Task { await eventsViewModel.fetchData() }
            }
        }
    }
}
