//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

@MainActor class AuthViewModel: ObservableObject {

    private enum Action {
        case signIn
        case resetPassword
        case signOut
    }

    @Published var currentUser: AuthUser?

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

    // MARK: Private properties

    private let authRepo: AuthRepository

    // MARK: Init

    init(authRepo: AuthRepository = FirebaseAuthRepository()) {
        self.authRepo = authRepo
        self.currentUser = authRepo.currentUser
    }
}

// MARK: Current user

extension AuthViewModel {

    func refreshCurrentUser() {
        currentUser = authRepo.currentUser
    }
}

// MARK: Sign in

extension AuthViewModel {

    func signIn() async {
        signInError = ""
        emailError = email.isEmpty ? AppError.emptyField.userMessage : ""
        pwdError = password.isEmpty ? AppError.emptyField.userMessage : ""
        guard emailError.isEmpty && pwdError.isEmpty else {
            return
        }
        isConnecting = true
        do {
            currentUser = try await authRepo.signIn(withEmail: email, password: password)
        } catch {
            handleAuthRepoError(error, for: .signIn)
        }
        isConnecting = false
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
        do {
            try await authRepo.sendPasswordReset(withEmail: email)
            resetPasswordSuccess = "Password reset email sent successfully!"
        } catch {
            handleAuthRepoError(error, for: .resetPassword)
        }
        isReseting = false
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
}

// MARK: Handle errors

extension AuthViewModel {

    private func handleAuthRepoError(_ error: any Error, for action: Action) {
        let nsError = error as NSError
        print("💥 \(action) error \(nsError.code): \(nsError.localizedDescription)")

        let appError = AppError(forCode: nsError.code)
        let message = appError.userMessage
        
        switch action {
        case .signIn:
            if appError == .invalidEmailFormat {
                emailError = message
            } else {
                signInError = message
            }
        case .resetPassword:
            resetPasswordError = message
        case .signOut:
            signOutError = message
        }
    }
}
