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

    func fetchEvents() async throws -> [Event] {
        if networkError {
            throw AppError.networkError
        }
        /// Set decoder date string format (like json file content)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        /// Try to return decoded data
        let event = try decoder.decode(Event.self, from: getData(jsonFile: "Event"))
        return [event]
    }
    
    func fetchCategories() async throws -> [EventCategory] {
        if networkError {
            throw AppError.networkError
        }
        let category = try JSONDecoder().decode(EventCategory.self, from: getData(jsonFile: "EventCategory"))
        return [category]
    }

    func addEvent(_ event: Eventorias.Event, image: UIImage) async throws {
        if networkError {
            throw AppError.networkError
        }
    }
}

private extension MockEventRepository {

    func getData(jsonFile: String) -> Data {
        /// Get bundle for json localization
        let bundle = Bundle(for: MockEventRepository.self)

        /// Create url
        guard let url = bundle.url(forResource: jsonFile, withExtension: "json") else {
            return Data()
        }
        /// Return data
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return Data()
        }
    }
}
