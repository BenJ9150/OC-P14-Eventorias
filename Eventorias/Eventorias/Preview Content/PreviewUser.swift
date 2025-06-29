//
//  PreviewUser.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import Foundation

struct PreviewUser: AuthUser {

    let uid = UUID().uuidString
    var email: String?
    var displayName: String?
    var avatarURL: URL?

    init(email: String? = nil) {
        if let currentEmail = email {
            self.email = currentEmail
        } else {
            self.email = AppFlags.previewEmail
        }
        self.displayName = AppFlags.previewName
        self.avatarURL = getAvatarURL()
    }

    init(email: String?, name: String?, avatarURL: URL?) {
        self.email = email
        self.displayName = name
        self.avatarURL = avatarURL
    }

    init(email: String?, name: String?, withAvatar: Bool) {
        self.email = email
        self.displayName = name
        if withAvatar {
            self.avatarURL = getAvatarURL()
        }
    }
//    init(email: String? = nil, name: String? = nil, avatarURL: URL? = nil) {
//        if let currentEmail = email {
//            self.email = currentEmail
//        }
//        if let currentName = name {
//            self.displayName = currentName
//        }
//        if let currentAvatarURL = avatarURL {
//            self.avatarURL = currentAvatarURL
//        } else {
//            self.avatarURL = getAvatarURL()
//        }
//    }

    func createUserProfileChangeRequest() -> AuthUserProfile {
        class TempProfile: AuthUserProfile {
            var displayName: String?
            var photoURL: URL?
            func commitChanges() async throws {}
        }
        return TempProfile()
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
