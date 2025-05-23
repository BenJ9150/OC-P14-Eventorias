//
//  MockEvent.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 23/05/2025.
//

import Foundation
@testable import Eventorias

class MockEvent {

    func event() -> Event {
        return Event(
            createdBy: "xxxxxxxxxxxxx",
            avatar: "",
            address: "67 Parc Solidaire, Stade Municipal, Toulouse, 31000, France",
            category: "charity_volunteering",
            date: .now,
            description: "Participate in our Charity Run to support local NGOs. All participants get a T-shirt and a finisher medal!",
            photoURL: "",
            title: "Charity run"
        )
    }
}
