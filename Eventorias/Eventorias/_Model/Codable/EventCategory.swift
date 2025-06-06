//
//  Category.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

struct EventCategory: Identifiable, Codable, Hashable {
    var id: String?
    var name: String
    var emoji: String
}

extension EventCategory {

    static let categoryPlaceholder = EventCategory(
        id: "select_category",
        name: "Select a category",
        emoji: ""
    )
}
