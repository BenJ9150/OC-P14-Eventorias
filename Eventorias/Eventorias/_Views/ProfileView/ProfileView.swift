//
//  ProfileView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showUpdateButtons = false

    var body: some View {
        VStack(spacing: 0) {
            titleAndAvatar
            ScrollView {
                VStack {
                    textFields
                    updateButtons
                }
            }
            .scrollIndicators(.hidden)
            Button("Sign out") {
                viewModel.signOut()
            }
            .buttonStyle(AppButtonPlain(small: true))
            .padding()
        }
        .padding(.horizontal)
        .onTapGesture {
            hideKeyboard()
        }
        /// Need new authentification to update email alert
        .alert(
            AppError.emailUpdateNeedAuth.userMessage,
            isPresented: $viewModel.showNeedAuthAlert
        ) {
            Button("Sign out", role: .destructive, action: { viewModel.signOutToRefreshAuth() })
            Button("Cancel", role: .cancel, action: { viewModel.refreshCurrentUser() })
        }
        /// Need to comfirm new email alert
        .alert("Success!", isPresented: $viewModel.showConfirmEmailAlert) {
            Button("Sign out", role: .destructive, action: { viewModel.signOut() })
            Button("Cancel", role: .cancel, action: { viewModel.refreshCurrentUser() })
        } message: {
            Text("A confirmation email has been sent to your new email address.\n\n")
            + Text("Once confirmed, you will need to log in again using this new email.")
        }
    }
}

// MARK: Avatar

private extension ProfileView {

    var titleAndAvatar: some View {
        HStack {
            Text("User profile")
                .foregroundStyle(.white)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            ImageView(url: viewModel.userPhoto, isAvatar: true)
                .frame(width: 48, height: 48)
                .mask(Circle())
        }
        .padding(.bottom, 24)
    }
}

// MARK: Textfields

private extension ProfileView {

    var textFields: some View {
        VStack(spacing: 0) {
            AppTextFieldView(
                "Name",
                text: $viewModel.userName,
                prompt: "Enter your name"
            )
            .textContentType(.name)
            .submitLabel(.done)
            .onChange(of: viewModel.userName) { _, newValue in
                if newValue != viewModel.currentUser?.displayName {
                    showUpdateButtons = true
                } else {
                    showUpdateButtons = false
                }
            }

            AppTextFieldView(
                "Email",
                text: $viewModel.email,
                prompt: "Enter your email",
                error: $viewModel.emailError
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .submitLabel(.done)
            .onChange(of: viewModel.email) { _, newValue in
                if newValue != viewModel.currentUser?.email {
                    showUpdateButtons = true
                } else {
                    showUpdateButtons = false
                }
            }
        }
        /// Set max width for iPad or iphone in landscape
        .frame(maxWidth: 440)
    }
}

// MARK: Update buttons

private extension ProfileView {

    var updateButtons: some View {
        VStack {
            if viewModel.isUpdating {
                AppProgressView()
                    .padding()
            } else if showUpdateButtons || !viewModel.updateError.isEmpty {
                if !viewModel.updateError.isEmpty {
                    ErrorView(error: viewModel.updateError)
                }
                Button("Update") {
                    hideKeyboard()
                    showUpdateButtons = false
                    Task { await viewModel.udpate() }
                }
                .buttonStyle(AppButtonPlain(small: true))
                
                Button("Cancel") {
                    hideKeyboard()
                    viewModel.cancelProfileUpdate()
                }
                .buttonStyle(AppButtonBorderless())
                .padding(.bottom, 48)
            }
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    ZStack {
        Color.mainBackground
            .ignoresSafeArea()
        ProfileView()
    }
}
