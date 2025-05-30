//
//  String+Keywords.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 30/05/2025.
//

import Foundation

extension String {

    func keywords() -> [String] {
        self
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .none)
            .replacingOccurrences(of: "’", with: " ")
            .replacingOccurrences(of: "'", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { String($0) }
    }
}
