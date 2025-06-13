//
//  AuthRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation

protocol AuthRepository {

    var currentUser: AuthUser? { get }
    func signIn(withEmail email: String, password: String) async throws -> AuthUser
    func sendPasswordReset(withEmail email: String) async throws
    func signOut() throws
    func createUser(withEmail email: String, password: String) async throws -> AuthUser
    func updateUser(displayName: String, photoURL: URL?) async throws
    func updateUserEmail(with email: String) async throws
    func reloadUser() async throws
}
