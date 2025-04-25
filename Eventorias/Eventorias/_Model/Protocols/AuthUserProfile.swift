//
//  AuthUserProfile.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import Foundation

protocol AuthUserProfile {
    var displayName: String? { get set }
    var photoURL: URL? { get set }
    func commitChanges() async throws
}
