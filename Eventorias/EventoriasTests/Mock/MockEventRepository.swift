//
//  MockEventRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockEventRepository {

    // MARK: Init
    
    private var networkError: Bool
    
    init(withNetworkError networkError: Bool = false) {
        self.networkError = networkError
    }
}

// MARK: EventRepository protocol

extension MockEventRepository: EventRepository {

    func fetchEvent(withId eventId: String) async throws -> Event? {
        try canPerform()
        return MockData().event()
    }

    func fetchEvents(orderBy: DBSorting, from categories: [EventCategory]) async throws -> [Event] {
        try canPerform()
        return MockData().events()
    }
    
    func fetchCategories() async throws -> [EventCategory] {
        try canPerform()
        return MockData().eventCategories()
    }

    func addEvent(_ event: Eventorias.Event, image: UIImage) async throws {
        try canPerform()
    }

    func searchEvents(with query: String) async throws -> [Event] {
        try canPerform()
        let searchTerm = query.keywords()
        return MockData().events().filter { event in
            !Set(event.keywords).isDisjoint(with: searchTerm)
        }
    }

    func addParticipant(eventId: String?, userId: String?) async throws {
        try canPerform()
    }
    
    func removeParticipant(eventId: String?, userId: String?) async throws {
        try canPerform()
    }
}

// MARK: Private

extension MockEventRepository {

    private func canPerform() throws {
        if networkError {
            throw AppError.networkError
        }
    }
}
