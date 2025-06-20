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
        if networkError {
            throw AppError.networkError
        }
        return MockData().event()
    }

    func fetchEvents(orderBy: DBSorting, from categories: [EventCategory]) async throws -> [Event] {
        if networkError {
            throw AppError.networkError
        }
        return MockData().events()
    }
    
    func fetchCategories() async throws -> [EventCategory] {
        if networkError {
            throw AppError.networkError
        }
        return MockData().eventCategories()
    }

    func addEvent(_ event: Eventorias.Event, image: UIImage) async throws {
        if networkError {
            throw AppError.networkError
        }
    }

    func searchEvents(with query: String) async throws -> [Event] {
        if networkError {
            throw AppError.networkError
        }
        let searchTerm = query.keywords()
        return MockData().events().filter { event in
            !Set(event.keywords).isDisjoint(with: searchTerm)
        }
    }
}
