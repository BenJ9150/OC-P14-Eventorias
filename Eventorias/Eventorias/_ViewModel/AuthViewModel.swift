//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import SwiftUI

@MainActor class AuthViewModel: ObservableObject {

    @Published var currentUser: AuthUser?

    // MARK: Sign in properties

    @Published var isConnecting = false
    @Published var email = ""
    @Published var password = ""

    // Sign in error
    @Published var emailError = ""
    @Published var pwdError = ""
    @Published var signInError = ""
    @Published var signOutError = ""

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
        guard fieldsNotEmpty() else {
            return
        }
        isConnecting = true
        do {
            currentUser = try await authRepo.signIn(withEmail: email, password: password)
        } catch let error as NSError {
            print("💥 Sign in error \(error.code): \(error.localizedDescription)")
            signInError = AppError(forCode: error.code).userMessage
        }
        isConnecting = false
    }

    private func fieldsNotEmpty() -> Bool {
        emailError = email.isEmpty ? AppError.emptyField.userMessage : ""
        pwdError = password.isEmpty ? AppError.emptyField.userMessage : ""
        return emailError.isEmpty && pwdError.isEmpty
    }
}

// MARK: Sign out

extension AuthViewModel {

    func signOut() {
        do {
            try authRepo.signOut()
        } catch let error as NSError {
            print("💥 Sign out error \(error.code): \(error.localizedDescription)")
            signOutError = AppError(forCode: error.code).userMessage
        }
        refreshCurrentUser()
    }
}
