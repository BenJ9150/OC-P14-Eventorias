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

    private var networkError: Bool
    private var decodingError: Bool

    init(withNetworkError networkError: Bool = false) {
        self.networkError = networkError
        self.decodingError = false
    }

    init(withDecodingError decodingError: Bool) {
        self.networkError = false
        self.decodingError = decodingError
    }

    // MARK: DatabaseRepository protocol

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository] {
        if networkError {
            throw AppError.networkError
        }
        return [MockDocumentRepository(withDecodingError: decodingError)]
    }
}
