//
//  View+UIDevice.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

extension View {
    var isPad: Bool {
        UIDevice.isPad
    }
}

extension UIDevice {
    static let isPad = current.userInterfaceIdiom == .pad
}
