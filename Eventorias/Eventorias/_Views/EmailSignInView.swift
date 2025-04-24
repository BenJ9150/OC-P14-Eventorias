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

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground
                    .opacity(0.95)
                    .ignoresSafeArea()

                ScrollView {
                    textFields
                    signInButton
                    forgotPwdButton
                }
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
        }
    }
}

// MARK: TextFields

private extension EmailSignInView {

    var textFields: some View {
        VStack(spacing: 0) {
            TextField(appPrompt: "Enter your email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(AppTextFieldStyle(title: "Email", error: $viewModel.emailError))
            
            SecureField(appPrompt: "Enter your password", text: $viewModel.password)
                .textContentType(.password)
                .textFieldStyle(AppTextFieldStyle(title: "Password", error: $viewModel.pwdError))
        }
    }
}

// MARK: Sign in button

private extension EmailSignInView {

    var signInButton: some View {
        ZStack {
            if viewModel.isConnecting {
                AppProgressView()
            } else {
                VStack {
                    if !viewModel.signInError.isEmpty {
                        ErrorView(error: viewModel.signInError)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    Button {
                        Task { await viewModel.signIn() }
                    } label: {
                        Text("Sign in")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(AppButtonPlain())
                }
            }
        }
        .animation(.easeIn(duration: 0.2), value: viewModel.signInError)
        .frame(minHeight: 52)
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
