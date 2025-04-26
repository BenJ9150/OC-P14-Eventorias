//
//  DatabaseRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

protocol DatabaseRepository {
    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository]
}

enum CollectionName: String {
    case events
    case categories
}
