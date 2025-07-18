//
//  EmailSignUpView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import SwiftUI

struct EmailSignUpView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    @FocusState private var pwdIsFocused: Bool
    @FocusState private var nameIsFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea()

                /// Use scrollView to see all error text for high dynamic sizes
                ScrollView {
                    LargeTitleView(title: "Sign up")
                    textFields
                    if !viewModel.signUpError.isEmpty {
                        ErrorView(error: viewModel.signUpError)
                            .padding(.bottom)
                    }
                    signUpButton
                }
                .frame(maxWidth: .maxWidthForPad)
                .animation(.easeInOut(duration: 0.3), value: viewModel.signUpError)
                .scrollIndicators(.hidden)
                .padding()
            }
            .withBackButton {
                dismiss()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

// MARK: TextFields

private extension EmailSignUpView {

    var textFields: some View {
        VStack(spacing: 0) {
            AppTextFieldView(
                "Email",
                text: $viewModel.email,
                prompt: "Enter your email",
                error: $viewModel.emailError
            )
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
            .textContentType(.newPassword)
            .focused($pwdIsFocused)
            .submitLabel(.next)
            .onSubmit { nameIsFocused = true }

            AppTextFieldView("Name", text: $viewModel.userName, prompt: "Enter your name")
                .textContentType(.name)
                .focused($nameIsFocused)
                .submitLabel(.join)
                .onSubmit {
                    Task { await viewModel.signUp() }
                }
        }
    }
}

// MARK: Sign in button

private extension EmailSignUpView {

    @ViewBuilder
    var signUpButton: some View {
        if viewModel.isCreating {
            AppProgressView()
                .frame(minHeight: 52)
        } else {
            Button {
                hideKeyboard()
                Task { await viewModel.signUp() }
            } label: {
                Text("Sign up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AppButtonPlain())
        }
    }
}


// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel(withError: true)) {
    @Previewable @EnvironmentObject var viewModel: AuthViewModel
    EmailSignUpView()
        .onAppear {
            viewModel.email = "test@example.com"
            viewModel.password = "xxxxx"
        }
}
