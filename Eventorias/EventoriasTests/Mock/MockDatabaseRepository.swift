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

    private var error: Bool
    init(withError error: Bool = false) {
        self.error = error
    }

    // MARK: DatabaseRepository protocol

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository] {
        return [MockDocumentRepository(withError: error)]
    }
}
