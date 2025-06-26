//
//  AppUserRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/06/2025.
//

import Foundation
import SwiftUI

class AppUserRepository: UserRepository {

    private let authRepo: AuthRepository
    private let dbRepo: DatabaseRepository
    private let storageRepo: StorageRepository
    
    init(
        authRepo: AuthRepository = FirebaseAuthRepository(),
        dbRepo: DatabaseRepository = FirebaseFirestoreRepository(),
        storageRepo: StorageRepository = FirebaseStorageRepository()
    ) {
        self.authRepo = authRepo
        self.dbRepo = dbRepo
        self.storageRepo = storageRepo
    }
}

// MARK: Sign up

extension AppUserRepository {

    func signUp(email: String, password: String, name: String) async throws -> AuthUser {
        let currentUser = try await authRepo.createUser(withEmail: email, password: password)
        if !name.isEmpty {
            return try await authRepo.updateUser(displayName: name, photoURL: nil)
        }
        return currentUser
    }
}

// MARK: Sign in

extension AppUserRepository {

    func signIn(withEmail email: String, password: String) async throws -> AuthUser {
        return try await authRepo.signIn(withEmail: email, password: password)
    }
}

// MARK: Sign out

extension AppUserRepository {

    func signOut() throws {
        try authRepo.signOut()
    }
}

// MARK: Reset password

extension AppUserRepository {

    func sendPasswordReset(withEmail email: String) async throws {
        try await authRepo.sendPasswordReset(withEmail: email)
    }
}

// MARK: User

extension AppUserRepository {

    func getUser() -> AuthUser? {
        authRepo.currentUser
    }

    func reloadUser() async {
        try? await authRepo.reloadUser()
    }
}

// MARK: Update user

extension AppUserRepository {

    func udpateUser(name: String, avatar: UIImage?) async throws -> AuthUser {
        guard let user = authRepo.currentUser else {
            throw AppError.currentUserNotFound
        }
        /// Update avatar on storage
        let photoURL = try await uploadNewAvatar(avatar: avatar, for: user)

        /// Update name and photo URL
        return try await authRepo.updateUser(displayName: name, photoURL: photoURL)
    }

    /// Returns true if email verification was sent
    func udpateUser(email: String) async throws -> Bool {
        guard email != authRepo.currentUser?.email else {
            /// Email already up to date
            return false
        }
        try await authRepo.sendEmailVerification(beforeUpdatingEmail: email)
        return true
    }

    func deleteUserPhoto() async throws -> AuthUser {
        guard let user = authRepo.currentUser else {
            throw AppError.currentUserNotFound
        }
        guard user.avatarURL != nil else {
            /// No avatar to delete
            return user
        }
        /// Delete user photo URL and image in storage
        let userUpdated = try await authRepo.updateUser(displayName: user.displayName, photoURL: nil)
        try await storageRepo.deleteFile(avatarName(for: user), from: .avatars)

        /// Update avatar of events created by the user
        try? await dbRepo.updateDocuments(
            into: .events,
            where: "createdBy",
            isEqualTo: user.uid,
            fieldToUpdate: "avatar",
            newValue: ""
        )
        return userUpdated
    }
}

// MARK: Private

extension AppUserRepository {

    private func uploadNewAvatar(avatar: UIImage?, for user: AuthUser) async throws -> URL? {
        guard let image = avatar else {
            /// No update, use current URL
            return user.avatarURL
        }
        /// Upload compressed image
        let imageData = try image.jpegData(maxSize: 300)
        let newURL = try await storageRepo.putData(imageData, into: .avatars, fileName: avatarName(for: user))

        /// Update avatar of events created by the user
        try await dbRepo.updateDocuments(
            into: .events,
            where: "createdBy",
            isEqualTo: user.uid,
            fieldToUpdate: "avatar",
            newValue: newURL
        )
        return URL(string: newURL)
    }

    private func avatarName(for user: AuthUser) -> String {
        return "\(user.uid).jpg"
    }
}
