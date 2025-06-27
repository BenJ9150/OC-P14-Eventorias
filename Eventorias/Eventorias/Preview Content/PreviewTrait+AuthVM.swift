//
//  PreviewModifiers.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import SwiftUI

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {

    static func withAuthViewModel(withError error: Bool = false) -> Self {
        AuthViewModelPreview.error = error
        return .modifier(AuthViewModelPreview())
    }

    static func withViewModels() -> Self {
        .modifier(ViewModelsPreview())
    }
}

struct AuthViewModelPreview: PreviewModifier {
    static var error: Bool = false

    static func makeSharedContext() async throws -> AuthViewModel {
        let userRepo = PreviewUserRepository(withError: error ? 17020 : nil)
        let authViewModel = AuthViewModel(userRepo: userRepo)
        authViewModel.refreshCurrentUser()
        return authViewModel
    }

    func body(content: Content, context: AuthViewModel) -> some View {
        content.environmentObject(context)
    }
}

struct ViewModelsPreview: PreviewModifier {

    @StateObject var eventsViewModel = EventsViewModel(eventRepo: PreviewEventRepository())

    static func makeSharedContext() async throws -> AuthViewModel {
        let userRepo = PreviewUserRepository()
        let authViewModel = AuthViewModel(userRepo: userRepo)
        
        return authViewModel
    }

    func body(content: Content, context: AuthViewModel) -> some View {
        content
            .environmentObject(context)
            .environmentObject(eventsViewModel)
            .onAppear {
                Task {
                    await eventsViewModel.fetchData()
                }
            }
    }
}
