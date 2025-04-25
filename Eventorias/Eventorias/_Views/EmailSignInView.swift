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

    @FocusState private var pwdIsFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .opacity(0.95)
                    .ignoresSafeArea()

                /// Use scrollView to see all error text for high dynamic sizes
                ScrollView {
                    textFields
                    signInButton
                    if !viewModel.signInError.isEmpty {
                        ErrorView(error: viewModel.signInError)
                            .padding(.top, 24)
                    }
                    forgotPwdButton
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.signInError)
                .scrollIndicators(.hidden)
                /// Set max width for iPad or iPhone in landscape
                .frame(maxWidth: 440)
                .padding()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.caption)
                            .bold()
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .foregroundStyle(.white)
                }
            }
            .onTapGesture {
                hideKeyboard()
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
                .submitLabel(.continue)
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
            // TODO
        }
        .buttonStyle(AppButtonBorderless())
        .padding(.top)
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    @Previewable @EnvironmentObject var viewModel: AuthViewModel
    EmailSignInView()
        .onAppear {
            viewModel.email = "test@example.com"
            viewModel.password = "xxxxx"
        }
}
