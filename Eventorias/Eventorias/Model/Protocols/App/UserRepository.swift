//
//  UserRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/06/2025.
//

import Foundation
import SwiftUI

protocol UserRepository {

    func signUp(email: String, password: String, name: String) async throws  -> AuthUser
    func signIn(withEmail email: String, password: String) async throws -> AuthUser
    func signOut() throws
    func sendPasswordReset(withEmail email: String) async throws

    func getUser() -> AuthUser?
    func reloadUser() async
    func udpateUser(name: String, avatar: UIImage?) async throws -> AuthUser
    func udpateUser(email: String) async throws -> Bool
    func deleteUserPhoto() async throws -> AuthUser
}
