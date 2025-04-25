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
                Color.sheetBackground
                    .ignoresSafeArea()

                /// Use scrollView to see all error text for high dynamic sizes
                ScrollView {
                    LargeTitleView(title: "Sign up")
                    textFields
                    signUpButton
                    if !viewModel.signUpError.isEmpty {
                        ErrorView(error: viewModel.signUpError)
                            .padding(.top, 24)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.signUpError)
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
            .submitLabel(.continue)
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
            .submitLabel(.continue)
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
#Preview(traits: .withAuthViewModelError()) {
    @Previewable @EnvironmentObject var viewModel: AuthViewModel
    EmailSignUpView()
        .onAppear {
            viewModel.email = "test@example.com"
            viewModel.password = "xxxxx"
        }
}
