//
//  AuthUserRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation
import FirebaseAuth

protocol AuthUser {
    var uid: String { get }
    var email: String? { get }
    var displayName: String? { get }
    var photoURL: URL? { get }
}

extension FirebaseAuth.User: AuthUser {}
