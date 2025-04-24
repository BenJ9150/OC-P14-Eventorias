//
//  SignInView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import SwiftUI

struct SignInView: View {

    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showEmailSignInView: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()
                
                if verticalSizeClass == .compact {
                    HStack(spacing: 24) {
                        eventoriasIcon
                        VStack(spacing: 0) {
                            Spacer()
                            signInButton
                            Spacer()
                            signUpButton
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    VStack(spacing: 0) {
                        Spacer()
                        eventoriasIcon
                        signInButton
                        Spacer()
                        Spacer()
                        signUpButton
                    }
                    /// Set max width for iPad
                    .frame(maxWidth: 440)
                    .padding(.horizontal, 74)
                }
            }
            .navigationDestination(isPresented: $showEmailSignInView, destination: {
                EmailSignInView()
            })
        }
    }
}

// MARK: Eventorias icon

private extension SignInView {

    var eventoriasIcon: some View {
        Image("logo_eventorias")
            .resizable()
            .scaledToFit()
    }
}

// MARK: Buttons

private extension SignInView {

    var signInButton: some View {
        Button {
            showEmailSignInView.toggle()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: "envelope.fill")
                Text("Sign in with email")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(AppButtonPlain())
        .padding(.top, verticalSizeClass == .compact ? 24 : 64)
    }

    var signUpButton: some View {
        VStack(spacing: 0) {
            Text("Don't have an account yet?")
                .foregroundStyle(Color.textGray)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility2)
                .fixedSize(horizontal: false, vertical: true)

            Button("Sign up") {
                // TODO
            }
            .buttonStyle(AppButtonBorderless())
        }
    }
}


// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    SignInView()
}
