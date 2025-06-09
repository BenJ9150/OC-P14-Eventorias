//
//  ProfileView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var viewModel: AuthViewModel

    @FocusState private var emailIsFocused: Bool
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
            .submitLabel(.continue)
            .onSubmit { emailIsFocused = true }

            AppTextFieldView(
                "Email",
                text: $viewModel.email,
                prompt: "Enter your email",
                error: $viewModel.emailError
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .focused($emailIsFocused)
            .submitLabel(.done)
        }
        /// Set max width for iPad or iphone in landscape
        .frame(maxWidth: 440)
        .onChange(of: viewModel.userName) { _, newValue in
            if newValue != viewModel.currentUser?.displayName {
                showUpdateButtons = true
            } else {
                showUpdateButtons = false
            }
        }
    }
}

// MARK: Update buttons

private extension ProfileView {

    var updateButtons: some View {
        VStack {
            if viewModel.isUpdating {
                AppProgressView()
                    .padding()
            } else if showUpdateButtons {
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
                    viewModel.refreshCurrentUser()
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
