//
//  Event.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

struct Event: Identifiable, Codable {
    var id: String?
    var createdBy: String
    var avatar: String
    var address: String
    var category: String
    var date: Date
    var description: String
    var photoURL: String
    var title: String
}
