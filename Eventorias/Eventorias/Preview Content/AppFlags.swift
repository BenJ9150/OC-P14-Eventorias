//
//  AppFlags.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 28/06/2025.
//

import SwiftUI

#if DEBUG

struct AppFlags {

    static let uiTesting = "--ui_testing"
    static let uiTestingSignIn = "--ui_testing_sign_in"

    static var isTesting: Bool {
        CommandLine.arguments.contains(uiTesting)
    }

    static var isTestingSignIn: Bool {
        CommandLine.arguments.contains(uiTestingSignIn)
    }
}

#endif
