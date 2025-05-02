//
//  MockDocumentRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
@testable import Eventorias

class MockDocumentRepository: DocumentRepository {

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

        /// Get json file name
        let file: String

        switch T.self {
        case is EventCategory.Type, is Optional<EventCategory>.Type:
            file = "EventCategory"
        case is Event.Type, is Optional<Event>.Type:
            file = "Event"
        default:
            fatalError("MockDocumentRepository: Unsupported type \(T.self)")
        }

        /// Set decoder date string format (like json file content)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        /// Try to return decoded data
        return try decoder.decode(T.self, from: getData(jsonFile: file))
    }
}

private extension MockDocumentRepository {

    func getData(jsonFile: String) -> Data {
        /// Get bundle for json localization
        let bundle = Bundle(for: MockDocumentRepository.self)

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
