//
//  SignInView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import SwiftUI

struct SignInView: View {

    @Environment(\.verticalSizeClass) var verticalSize
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var showEmailSignInView: Bool = false
    @State private var showEmailSignUpView: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()
                
                if verticalSize == .compact {
                    HStack(spacing: 48) {
                        eventoriasIcon
                            .frame(maxWidth: 200)
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
                    .frame(maxWidth: .maxWidthForPad)
                    .padding(.horizontal, 74)
                }
            }
            .navigationDestination(isPresented: $showEmailSignInView, destination: {
                EmailSignInView()
            })
            .navigationDestination(isPresented: $showEmailSignUpView, destination: {
                EmailSignUpView()
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
            .accessibilityHidden(true)
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
        .padding(.top, verticalSize == .compact ? 24 : 64)
    }

    var signUpButton: some View {
        VStack(spacing: 0) {
            Text("Don't have an account yet?")
                .foregroundStyle(Color.textGray)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityHidden(true)

            Button("Sign up") {
                showEmailSignUpView.toggle()
            }
            .buttonStyle(AppButtonBorderless())
            .accessibilityLabel("Don't have an account yet? Sign up")
        }
    }
}


// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel(withError: true)) {
    @Previewable @EnvironmentObject var viewModel: AuthViewModel
    SignInView()
        .onAppear {
            viewModel.email = "test@example.com"
            viewModel.password = "xxxxx"
        }
}
