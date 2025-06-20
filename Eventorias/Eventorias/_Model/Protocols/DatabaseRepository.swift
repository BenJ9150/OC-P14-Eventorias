//
//  DatabaseRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

protocol DatabaseRepository {

    func fetchDocument(into collection: CollectionName, docID: String) async throws -> DocumentRepository
    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository]
    func fetchUpcomingDoc(into collection: CollectionName, orderBy: DBSorting, where field: String, isIn filters: [String]) async throws -> [DocumentRepository]
    func addDocument<T: Encodable>(_ data: T, into collection: CollectionName) async throws
    func generateDocumentID(for collection: CollectionName) -> String
    func search(into collection: CollectionName, field: String, contains values: [String]) async throws -> [DocumentRepository]
}

enum CollectionName: String {
    case events
    case categories
}

enum DBSorting: String {
    case byDate = "date"
    case byTitle = "title"
}
