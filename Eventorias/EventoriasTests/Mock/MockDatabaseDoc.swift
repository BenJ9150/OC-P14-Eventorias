//
//  MockDatabaseDoc.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
@testable import Eventorias

class MockDatabaseDoc: DatabaseDoc {

    // MARK: Init

    private var decodingError: Bool
    init(withDecodingError decodingError: Bool) {
        self.decodingError = decodingError
    }

    // MARK: DocumentRepository protocol

    var documentID: String = UUID().uuidString
    
    func decodedData<T: Decodable>() throws -> T {
        /// Simulate decoding error
        if decodingError {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
        /// Return decoded data
        switch T.self {
        case is EventCategory.Type, is Optional<EventCategory>.Type:
            return MockData().eventCategory() as! T
        case is Event.Type, is Optional<Event>.Type:
            return MockData().event() as! T
        default:
            fatalError("MockDatabaseDoc: Unsupported type \(T.self)")
        }
    }
}
