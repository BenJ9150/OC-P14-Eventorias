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
    @State private var checkingUser = true

    /// Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            Group {
                if checkingUser {
                    ZStack {
                        Color.mainBackground
                            .ignoresSafeArea()
                        AppProgressView()
                    }
                } else if authViewModel.currentUser == nil {
                    SignInView()
                        .onDisappear {
                            /// User just sign in, fetch data
                            Task.detached { await eventsViewModel.fetchData() }
                        }
                } else {
                    CustomTabView()
                }
            }
            .environmentObject(authViewModel)
            .environmentObject(eventsViewModel)
            .onAppear {
                authViewModel.refreshCurrentUser()
                checkingUser = false
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                becomeActiveSetup()
            }
        }
    }
}

extension EventoriasApp {

    private func becomeActiveSetup() {
        Task {
            await authViewModel.reloadCurrentUser()
            if authViewModel.currentUser == nil {
                return
            }
            await eventsViewModel.fetchData()
        }
    }
}
