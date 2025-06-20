//
//  AuthUserRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 18/04/2025.
//

import Foundation

protocol AuthUser {

    var uid: String { get }
    var email: String? { get }
    var displayName: String? { get }
    var avatarURL: URL? { get }
    func createUserProfileChangeRequest() -> AuthUserProfile
}
