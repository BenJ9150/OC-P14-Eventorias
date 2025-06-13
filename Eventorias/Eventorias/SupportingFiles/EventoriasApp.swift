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
                    .onDisappear {
                        /// User just sign in, fetch data
                        Task { await eventsViewModel.fetchData() }
                    }
            } else {
                CustomTabView(eventsViewModel: eventsViewModel)
            }
        }
        .environmentObject(authViewModel)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                Task {
                    await authViewModel.reloadCurrentUser()
                    if authViewModel.currentUser == nil {
                        return
                    }
                    await eventsViewModel.fetchData()
                }
            }
        }
    }
}
