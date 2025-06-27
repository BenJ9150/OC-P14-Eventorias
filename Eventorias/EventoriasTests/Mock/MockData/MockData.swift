//
//  MockData.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 23/05/2025.
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockData {

    func event(participant: String = "xxxxxxxxxxxxx") -> Event {
        Event(
            id: "1",
            createdBy: "xxxxxxxxxxxxx",
            avatar: "",
            address: "67 Parc Solidaire, Stade Municipal, Toulouse, 31000, France",
            category: "charity_volunteering",
            date: .now,
            description: "Participate in our Charity Run to support local NGOs. All participants get a T-shirt and a finisher medal!",
            photoURL: "",
            title: "Charity run",
            keywords: ["charity", "run"],
            participants: [participant]
        )
    }

    func events() -> [Event] {
        [event()]
    }

    func eventCategory() -> EventCategory {
        EventCategory(id: "art_exhibitions", name: "Art & Exhibitions", emoji: "🎨")
    }

    func eventCategories() -> [EventCategory] {
        [eventCategory(), EventCategory(id: nil, name: "test", emoji: "")]
    }

    func image() -> UIImage {
        return UIImage(named: "ImageTest", in: Bundle(for: MockData.self), with: nil)!
    }

    func user() -> AuthUser {
        MockUser(email: "test@gmail.com", displayName: "Test", photoURL: nil)
    }
}
