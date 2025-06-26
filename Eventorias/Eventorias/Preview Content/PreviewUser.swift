//
//  PreviewUser.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import Foundation

struct PreviewUser: AuthUser {

    let uid = UUID().uuidString
    var email: String? = "preview@eventorias.com"
    var displayName: String? = "Jean-Baptiste"
    var avatarURL: URL? = nil

    init(email: String? = nil, name: String? = nil, avatarURL: URL? = nil) {
        if let currentEmail = email {
            self.email = currentEmail
        }
        if let currentName = name {
            self.displayName = currentName
        }
        if let currentAvatarURL = avatarURL {
            self.avatarURL = currentAvatarURL
        } else {
            self.avatarURL = getAvatarURL()
        }
    }

    func createUserProfileChangeRequest() -> AuthUserProfile {
        PreviewUserProfile()
    }

    private func getAvatarURL() -> URL {
        /// Get bundle for json localization
        let bundle = Bundle(for: PreviewUserRepository.self)

        /// Create url
        guard let url = bundle.url(forResource: "avatar", withExtension: "png") else {
            fatalError("Failed to get url of avatar.png")
        }
        return url
    }
}

struct PreviewUserProfile: AuthUserProfile {

    var displayName: String?
    var photoURL: URL?
    
    func commitChanges() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
