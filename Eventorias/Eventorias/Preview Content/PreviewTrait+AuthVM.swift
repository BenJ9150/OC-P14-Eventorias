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
}

struct AuthViewModelPreview: PreviewModifier {

    static func makeSharedContext() async throws -> AuthViewModel {
        let authViewModel = AuthViewModel(authRepo: PreviewAuthRepository())
        return authViewModel
    }

    func body(content: Content, context: AuthViewModel) -> some View {
        content
            .environmentObject(context)
    }
}
