//
//  MockAuthUser.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 22/04/2025.
//

import Foundation
@testable import Eventorias

struct MockUser: AuthUser {
    var uid = UUID().uuidString
    var email: String? = "test@eventorias.com"
    var displayName: String? = "test"
    var photoURL: URL? = nil
}
