//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

@MainActor class AuthViewModel: ObservableObject {

    private enum Action {
        case signUp
        case signIn
        case resetPassword
        case update
        case signOut
    }

    @Published var currentUser: AuthUser?

    // MARK: Sign up properties

    @Published var isCreating = false
    @Published var userName = ""
    @Published var userPhoto = ""
    @Published var signUpError = ""

    // MARK: Sign in properties

    @Published var isConnecting = false
    @Published var email = ""
    @Published var password = ""
    @Published var emailError = ""
    @Published var pwdError = ""
    @Published var signInError = ""
    @Published var signOutError = ""

    // MARK: Reset password properties

    @Published var isReseting = false
    @Published var resetPasswordSuccess = ""
    @Published var resetPasswordError = ""

    // MARK: Update properties

    @Published var showUpdateButtons = false
    @Published var isUpdating = false
    @Published var updateError = ""
    @Published var showNeedAuthAlert = false
    @Published var showConfirmEmailAlert = false
    @Published var newAvatar: UIImage?

    // MARK: Private properties

    private let authRepo: AuthRepository
    private let storageRepo: StorageRepository
    private let blanckUrl = URL(string: "about:blank")

    // MARK: Init

    init(
        authRepo: AuthRepository = FirebaseAuthRepository(),
        storageRepo: StorageRepository = FirebaseStorageRepository()
    ) {
        self.authRepo = authRepo
        self.storageRepo = storageRepo
        self.currentUser = authRepo.currentUser
    }
}

// MARK: Current user

extension AuthViewModel {

    func reloadCurrentUser() async {
        try? await authRepo.reloadUser()
        refreshCurrentUser()
    }

    func refreshCurrentUser() {
        currentUser = authRepo.currentUser
        refreshProfile()
    }

    private func refreshProfile() {
        userName = currentUser?.displayName ?? ""
        email = currentUser?.email ?? ""
        password.removeAll()
        refreshAvatar()
    }

    private func refreshAvatar() {
        newAvatar = nil
        userPhoto = currentUser?.avatarURL?.absoluteString ?? ""
    }
}

// MARK: Sign up

extension AuthViewModel {

    func signUp() async {
        signUpError = ""
        guard validateCredentials() else {
            return
        }
        isCreating = true
        defer { isCreating = false }
        do {
            currentUser = try await authRepo.createUser(withEmail: email, password: password)
            if !userName.isEmpty {
                try? await authRepo.updateUser(displayName: userName, photoURL: URL(string: userPhoto))
            }
            refreshProfile()
        } catch {
            handleAuthRepoError(error, for: .signUp)
        }
    }
}

// MARK: Sign in

extension AuthViewModel {

    func signIn() async {
        signInError = ""
        guard validateCredentials() else {
            return
        }
        isConnecting = true
        defer { isConnecting = false }
        do {
            currentUser = try await authRepo.signIn(withEmail: email, password: password)
            refreshProfile()
        } catch {
            handleAuthRepoError(error, for: .signIn)
        }
    }
}

// MARK: Reset password

extension AuthViewModel {

    func sendPasswordReset() async {
        resetPasswordSuccess = ""
        resetPasswordError = email.isEmpty ? AppError.emptyField.userMessage : ""
        guard resetPasswordError.isEmpty else {
            return
        }
        isReseting = true
        defer { isReseting = false }
        do {
            try await authRepo.sendPasswordReset(withEmail: email)
            resetPasswordSuccess = "Password reset email sent successfully!"
        } catch {
            handleAuthRepoError(error, for: .resetPassword)
        }
    }
}

// MARK: Update

extension AuthViewModel {

    func udpate() async {
        guard let user = currentUser else {
            updateError = AppError.currentUserNotFound.userMessage
            return
        }
        updateError = ""
        isUpdating = true
        defer { isUpdating = false }
        do {
            /// Update avatar on storage
            let newPhotoUrl = try await updateAvatarOnStorage(user: user)

            /// Update name and photo URL
            try await authRepo.updateUser(displayName: userName, photoURL: newPhotoUrl)

            /// Update local avatar data
            refreshAvatar()
            
            /// Update email
            if email != currentUser?.email {
                try await authRepo.sendEmailVerification(beforeUpdatingEmail: email)
                showConfirmEmailAlert.toggle()
            }
        } catch {
            handleAuthRepoError(error, for: .update)
        }
    }

    func cancelProfileUpdate() {
        updateError.removeAll()
        refreshProfile()
        showUpdateButtons = false
    }

    func showUpdateButtonsIfNeeded() {
        let show = currentUser?.displayName != userName
            || currentUser?.email != email
            || newAvatar != nil
            || (currentUser?.avatarURL?.absoluteString ?? "") != userPhoto

        showUpdateButtons = show
    }

    private func updateAvatarOnStorage(user: any AuthUser) async throws -> URL? {
        let file = "\(user.uid).jpg"
        
        /// Upload new avatar (or replace current image if already set)
        if let image = newAvatar {
            let imageData = try image.jpegData(maxSize: 300)
            let newURL = try await storageRepo.putData(imageData, into: .avatars, fileName: file)
            return URL(string: newURL)
        }

        /// Delete avatar from storage
        if userPhoto.isEmpty && user.avatarURL != nil {
            try await storageRepo.deleteFile(file, from: .avatars)
            return nil
        }

        /// return current URL, no update
        return user.avatarURL
    }
}

// MARK: Sign out

extension AuthViewModel {

    func signOut() {
        signOutError = ""
        do {
            try authRepo.signOut()
        } catch {
            handleAuthRepoError(error, for: .signOut)
        }
        refreshCurrentUser()
    }

    func signOutToRefreshAuth() {
        /// Save current email to display it in sign in view
        let currentEmail = currentUser?.email
        signOut()

        /// Set current email for sign in view
        if let savedEmail = currentEmail {
            email = savedEmail
        }
    }
}

// MARK: Handle errors

extension AuthViewModel {

    private func handleAuthRepoError(_ error: any Error, for action: Action) {
        let nsError = error as NSError
        print("💥 \(action) error \(nsError.code): \(nsError.localizedDescription)")

        let appError = AppError(forCode: nsError.code)
        let message = appError.userMessage
        
        switch action {
        case .signUp:
            if appError == .invalidEmailFormat {
                emailError = message
            } else {
                signUpError = message
            }
        case .signIn:
            if appError == .invalidEmailFormat {
                emailError = message
            } else {
                signInError = message
            }
        case .resetPassword:
            resetPasswordError = message
        case .update:
            if appError == .emailUpdateNeedAuth {
                showNeedAuthAlert.toggle()
            } else {
                updateError = message
            }
        case .signOut:
            signOutError = message
        }
    }

    private func validateCredentials() -> Bool {
        emailError = email.isEmpty ? AppError.emptyField.userMessage : ""
        pwdError = password.isEmpty ? AppError.emptyField.userMessage : ""
        return emailError.isEmpty && pwdError.isEmpty
    }
}
