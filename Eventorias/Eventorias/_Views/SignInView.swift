//
//  SignInView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import SwiftUI

struct SignInView: View {

    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Text("Sign in")
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    SignInView()
}
