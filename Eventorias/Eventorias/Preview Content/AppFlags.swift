//
//  AppFlags.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 28/06/2025.
//

import SwiftUI

#if DEBUG

struct AppFlags {

    static let previewEmail = "preview@eventorias.com"
    static let previewName = "Jean-Baptiste"

    static let uiTestingSignIn = "--ui_testing_sign_in"
    static let uiTesting = "--ui_testing"
    static let uiTestingNotif = "--ui_testing_notif"
    static let uiTestingUpdateNeedAuth = "--ui_testing_update_need_auth"

    static var isTestingSignIn: Bool {
        CommandLine.arguments.contains(uiTestingSignIn)
    }

    static var isTestingNotif: Bool {
        CommandLine.arguments.contains(uiTestingNotif)
    }

    static var isTestingUpdateNeedAuth: Bool {
        CommandLine.arguments.contains(uiTestingUpdateNeedAuth)
    }

    static var isTesting: Bool {
        if CommandLine.arguments.contains(uiTesting) { return true }
        if CommandLine.arguments.contains(uiTestingSignIn) { return true }
        if CommandLine.arguments.contains(uiTestingNotif) { return true }
        if CommandLine.arguments.contains(uiTestingUpdateNeedAuth) { return true }
        return false
    }
}

#endif
