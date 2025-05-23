//
//  DatabaseRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

protocol DatabaseRepository {

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository]
    func addDocument<T: Encodable>(_ data: T, into collection: CollectionName) async throws
}

enum CollectionName: String {
    case events
    case categories
}
