//
//  PasswordResetView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import SwiftUI

struct PasswordResetView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sheetBackground
                    .ignoresSafeArea()

                /// Use scrollView to see all error text for high dynamic sizes
                ScrollView {
                    LargeTitleView(title: "Reset password")
                    AppTextFieldView("Email", text: $viewModel.email, prompt: "Enter your email", error: $viewModel.emailError)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .submitLabel(.send)
                        .onSubmit {
                            Task { await viewModel.sendPasswordReset() }
                        }

                    if !viewModel.resetPasswordSuccess.isEmpty {
                        Text(viewModel.resetPasswordSuccess)
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.textSuccess)
                            .padding()
                            .padding(.bottom)
                    }
                    
                    resetButton
                    if !viewModel.resetPasswordError.isEmpty {
                        ErrorView(error: viewModel.resetPasswordError)
                            .padding(.top, 24)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.resetPasswordSuccess)
                .animation(.easeInOut(duration: 0.3), value: viewModel.resetPasswordError)
                .scrollIndicators(.hidden)
                /// Set max width for iPad or iPhone in landscape
                .frame(maxWidth: 440)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
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

// MARK: Reset button

private extension PasswordResetView {

    @ViewBuilder
    var resetButton: some View {
        if viewModel.isReseting {
            AppProgressView()
                .frame(minHeight: 52)
        } else {
            Button {
                hideKeyboard()
                Task { await viewModel.sendPasswordReset() }
            } label: {
                Text("Send password reset")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AppButtonPlain())
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    @Previewable @EnvironmentObject var viewModel: AuthViewModel
    PasswordResetView()
        .onAppear {
            viewModel.email = "test@example.com"
        }
}
