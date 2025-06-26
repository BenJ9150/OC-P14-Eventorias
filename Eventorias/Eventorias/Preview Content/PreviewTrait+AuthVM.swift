//
//  PreviewModifiers.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import SwiftUI

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {

    static func withAuthViewModel() -> Self {
        .modifier(AuthViewModelPreview())
    }

    static func withAuthViewModelError() -> Self {
        .modifier(AuthViewModelPreviewWithError())
    }
}

struct AuthViewModelPreview: PreviewModifier {

    static func makeSharedContext() async throws -> AuthViewModel {
        let userRepo = PreviewUserRepository()
        let authViewModel = AuthViewModel(userRepo: userRepo)
        authViewModel.refreshCurrentUser()
        return authViewModel
    }

    func body(content: Content, context: AuthViewModel) -> some View {
        content
            .environmentObject(context)
    }
}

struct AuthViewModelPreviewWithError: PreviewModifier {

    static func makeSharedContext() async throws -> AuthViewModel {
        let userRepo = PreviewUserRepository(withError: 17020)
        let authViewModel = AuthViewModel(userRepo: userRepo)
        return authViewModel
    }

    func body(content: Content, context: AuthViewModel) -> some View {
        content
            .environmentObject(context)
    }
}
