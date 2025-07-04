//
//  EmailSignInView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct EmailSignInView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var showPasswordResetView = false
    @FocusState private var pwdIsFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()

                /// Use scrollView to see all error text for high dynamic sizes
                ScrollView {
                    LargeTitleView(title: "Sign in with Email")
                    textFields
                    if !viewModel.signInError.isEmpty {
                        ErrorView(error: viewModel.signInError)
                            .padding(.bottom)
                    }
                    signInButton
                    forgotPwdButton
                }
                .frame(maxWidth: .maxWidthForPad)
                .animation(.easeInOut(duration: 0.3), value: viewModel.signInError)
                .scrollIndicators(.hidden)
                .padding()
            }
            .withBackButton {
                dismiss()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(isPresented: $showPasswordResetView) {
                PasswordResetView()
            }
        }
    }
}

// MARK: TextFields

private extension EmailSignInView {

    var textFields: some View {
        VStack(spacing: 0) {
            AppTextFieldView("Email", text: $viewModel.email, prompt: "Enter your email", error: $viewModel.emailError)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .onSubmit { pwdIsFocused = true }

            AppTextFieldView(
                "Password",
                text: $viewModel.password,
                prompt: "Enter your password",
                error: $viewModel.pwdError,
                isSecure: true
            )
            .focused($pwdIsFocused)
            .submitLabel(.join)
            .onSubmit {
                Task { await viewModel.signIn() }
            }
        }
    }
}

// MARK: Sign in button

private extension EmailSignInView {

    @ViewBuilder
    var signInButton: some View {
        if viewModel.isConnecting {
            AppProgressView()
                .frame(minHeight: 52)
        } else {
            Button {
                hideKeyboard()
                Task { await viewModel.signIn() }
            } label: {
                Text("Sign in")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AppButtonPlain())
        }
    }
}

// MARK: Forgot password button

private extension EmailSignInView {

    var forgotPwdButton: some View {
        Button("Forgot password?") {
            showPasswordResetView.toggle()
        }
        .buttonStyle(AppButtonBorderless())
        .padding(.top)
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel(withError: true)) {
    @Previewable @EnvironmentObject var viewModel: AuthViewModel
    EmailSignInView()
        .onAppear {
            viewModel.email = "test@example.com"
            viewModel.password = "xxxxx"
        }
}
