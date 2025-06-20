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
        let authViewModel = AuthViewModel(
            authRepo: PreviewAuthRepository(),
            storageRepo: PreviewStorageRepository()
        )
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
        let authRepo = PreviewAuthRepository(withError: 17020)
        let authViewModel = AuthViewModel(authRepo: authRepo)
        return authViewModel
    }

    func body(content: Content, context: AuthViewModel) -> some View {
        content
            .environmentObject(context)
    }
}
