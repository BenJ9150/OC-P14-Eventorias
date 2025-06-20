//
//  Event.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

struct Event: Identifiable, Codable, Hashable {
    var id: String?
    var createdBy: String
    var avatar: String
    var address: String
    var category: String
    var date: Date
    var description: String
    var photoURL: String = ""
    var title: String
    var keywords: [String] = []

    // MARK: Share properties

    static let shareUrlScheme: String = "eventorias"
    static let shareUrlHost: String = "event"

    var shareURL: URL? {
        return URL(string: "\(Event.shareUrlScheme)://\(Event.shareUrlHost)/\(id ?? "")")
    }
}
