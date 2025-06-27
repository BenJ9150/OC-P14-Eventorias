//
//  MockDatabaseRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
@testable import Eventorias

// MARK: DatabaseRepository

class MockDatabaseRepository: DatabaseRepository {

    private var decodingError: Bool
    
    init(withDecodingError decodingError: Bool = false) {
        self.decodingError = decodingError
    }

    func fetchDocument(into collection: CollectionName, docID: String) async throws -> DatabaseDoc {
        return MockDatabaseDoc(withDecodingError: decodingError)
    }

    func fetchDocuments(into collection: CollectionName) async throws -> [DatabaseDoc] {
        return [MockDatabaseDoc(withDecodingError: decodingError)]
    }

    func fetchUpcomingDoc(into collection: CollectionName, orderBy: DBSorting, where field: String, isIn filters: [String]) async throws -> [DatabaseDoc] {
        return [MockDatabaseDoc(withDecodingError: decodingError)]
    }

    func generateDocumentID(for collection: CollectionName) -> String {
        return UUID().uuidString
    }

    func addDocument<T>(_ data: T, withID documentID: String, into collection: CollectionName) async throws where T : Encodable {}

    func updateDocuments(into collection: CollectionName, where field: String, isEqualTo value: Any, fieldToUpdate: String, newValue: Any) async throws {}

    func updateDocuments(into collection: CollectionName, withID documentID: String?, arrayToUpdate: String, addValue: Any?) async throws {}
    
    func updateDocuments(into collection: CollectionName, withID documentID: String?, arrayToUpdate: String, removeValue: Any?) async throws {}

    func search(into collection: CollectionName, field: String, contains values: [String]) async throws -> [DatabaseDoc] {
        return [MockDatabaseDoc(withDecodingError: decodingError)]
    }
}

// MARK: DatabaseDoc

class MockDatabaseDoc: DatabaseDoc {

    var documentID: String = UUID().uuidString
    private var decodingError: Bool

    init(withDecodingError decodingError: Bool) {
        self.decodingError = decodingError
    }
    
    func decodedData<T: Decodable>() throws -> T {
        if decodingError {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
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
