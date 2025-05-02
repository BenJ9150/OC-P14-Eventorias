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

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository] {
        return [MockDocumentRepository(withDecodingError: decodingError)]
    }
}
