//
//  ProfileView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

struct ProfileView: View {

    @Environment(\.verticalSizeClass) var verticalSize
    @Environment(\.scenePhase) var scenePhase

    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var notifViewModel: NotificationsViewModel

    // Avatar

    @State private var showPhotoPicker = false
    @State private var showCamera = false

    // MARK: Body

    var body: some View {
        bodyContent
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                viewModel.showUpdateButtonsIfNeeded()
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
        
            /// Need notifications authorization
            .alert("We need your permission to send notifications", isPresented: $notifViewModel.showPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable notifications for this app in Settings.")
            }
    }
}

// MARK: Body content

private extension ProfileView {

    @ViewBuilder private var bodyContent: some View {
        if verticalSize == .compact {
            HStack(spacing: 24) {
                VStack(alignment: .leading) {
                    titleAndAvatar
                    toggleNotifications
                    Spacer()
                    signOutButton
                }
                .padding(.vertical, 24)
                VStack(spacing: 0) {
                    ScrollView {
                        VStack {
                            textFields
                            updateButtons
                        }
                        .padding(.vertical, 24)
                    }
                    .scrollIndicators(.hidden)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        } else {
            VStack(spacing: 0) {
                titleAndAvatar
                ScrollView {
                    VStack {
                        textFields
                        toggleNotifications
                        updateButtons
                    }
                }
                .scrollIndicators(.hidden)
                signOutButton
            }
            .frame(maxWidth: .maxWidthForPad)
            .padding(.horizontal)
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
                .dynamicTypeSize(.xSmall ... .accessibility3)
                .accessibilityHidden(true)

            if verticalSize != .compact {
                Spacer()
            }

            Menu {
                Button {
                    showCamera.toggle()
                } label: {
                    Label("Take a photo", systemImage: "camera")
                }
                Button {
                    showPhotoPicker.toggle()
                } label: {
                    Label("Choose from library", systemImage: "paperclip")
                }
                if !viewModel.userPhoto.isEmpty {
                    Button {
                        viewModel.userPhoto.removeAll()
                    } label: {
                        Label("Delete avatar", systemImage: "xmark.circle")
                    }
                }
            } label: {
                Group {
                    if let newAvatar = viewModel.newAvatar {
                        Image(uiImage: newAvatar)
                            .resizable()
                            .scaledToFill()
                            .accessibilityLabel("Avatar")
                    } else {
                        ImageView(url: viewModel.userPhoto, isAvatar: true)
                    }
                }
                .frame(width: 48, height: 48)
                .mask(Circle())
            }
            .accessibilityIdentifier("UserAvatar")
        }
        .padding(.top, isPad ? 48 : 0)
        .padding(.bottom, isPad ? 48 : 24)
        .onChange(of: viewModel.newAvatar) {
            viewModel.showUpdateButtonsIfNeeded()
        }
        .onChange(of: viewModel.userPhoto) {
            viewModel.showUpdateButtonsIfNeeded()
        }
        .takePhoto(
            image: $viewModel.newAvatar,
            showCamera: $showCamera,
            showPhotoPicker: $showPhotoPicker
        )
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

            AppTextFieldView(
                "Email",
                text: $viewModel.email,
                prompt: "Enter your email",
                error: $viewModel.emailError
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .submitLabel(.done)
        }
        .onChange(of: viewModel.userName) {
            viewModel.showUpdateButtonsIfNeeded()
        }
        .onChange(of: viewModel.email) {
            viewModel.showUpdateButtonsIfNeeded()
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
            } else if viewModel.showUpdateButtons || !viewModel.updateError.isEmpty {
                if !viewModel.updateError.isEmpty {
                    ErrorView(error: viewModel.updateError)
                }
                Button("Update") {
                    hideKeyboard()
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
        .padding(.top, 24)
    }
}

// MARK: Sign out button

private extension ProfileView {

    @ViewBuilder var signOutButton: some View {
        if !viewModel.showUpdateButtons && viewModel.updateError.isEmpty {
            Button("Sign out") {
                viewModel.signOut()
            }
            .buttonStyle(AppButtonPlain(small: true))
            .padding(.all, verticalSize == .compact ? 0 : 16)
        }
    }
}

// MARK: Notifications

private extension ProfileView {

    var toggleNotifications: some View {
        HStack(spacing: 12) {
            ToggleView(title: "Notifications",isOn: notifViewModel.toggleNotifications) { newValue in
                await notifViewModel.toggle(to: newValue)
            }
            if verticalSize != .compact {
                Spacer()
            }
        }
        .dynamicTypeSize(.xSmall ... .accessibility3)
        .padding(.top, verticalSize == .compact ? -4 : 8)
        .task { await notifViewModel.updateStatus() }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                Task { await notifViewModel.updateStatus() }
            }
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel(withError: false)) {
    @Previewable @EnvironmentObject var viewModel: AuthViewModel
    ZStack {
        Color.mainBackground
            .ignoresSafeArea()
        ProfileView(notifViewModel: NotificationsViewModel(notifRepo: PreviewNotifRepository()))
            .onAppear {
//                viewModel.email = "test@test.com"
            }
    }
}
