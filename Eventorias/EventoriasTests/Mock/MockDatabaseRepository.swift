//
//  MockDatabaseRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
@testable import Eventorias

class MockDatabaseRepository: DatabaseRepository {

    // MARK: Init

    private var decodingError: Bool
    
    init(withDecodingError decodingError: Bool = false) {
        self.decodingError = decodingError
    }

    // MARK: DatabaseRepository protocol

    func fetchDocument(into collection: CollectionName, docID: String) async throws -> DatabaseDoc {
        return MockDatabaseDoc(withDecodingError: decodingError)
    }

    func fetchDocuments(into collection: CollectionName) async throws -> [DatabaseDoc] {
        return [MockDatabaseDoc(withDecodingError: decodingError)]
    }

    func fetchUpcomingDoc(into collection: CollectionName, orderBy: DBSorting, where field: String, isIn filters: [String]) async throws -> [DatabaseDoc] {
        return [MockDatabaseDoc(withDecodingError: decodingError)]
    }

    func addDocument<T>(_ data: T, into collection: Eventorias.CollectionName) async throws where T : Encodable {}

    func generateDocumentID(for collection: Eventorias.CollectionName) -> String {
        return UUID().uuidString
    }

    func search(into collection: Eventorias.CollectionName, field: String, contains values: [String]) async throws -> [DatabaseDoc] {
        return [MockDatabaseDoc(withDecodingError: decodingError)]
    }
}
