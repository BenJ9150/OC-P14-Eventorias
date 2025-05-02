//
//  PreviewDatabaseRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation

class PreviewDatabaseRepository: DatabaseRepository {

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository] {
        return []
    }
}
