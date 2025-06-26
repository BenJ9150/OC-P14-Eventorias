//
//  DatabaseRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

protocol DatabaseRepository {

    func fetchDocument(into collection: CollectionName, docID: String) async throws -> DatabaseDoc
    func fetchDocuments(into collection: CollectionName) async throws -> [DatabaseDoc]
    func fetchUpcomingDoc(into collection: CollectionName, orderBy: DBSorting, where field: String, isIn filters: [String]) async throws -> [DatabaseDoc]
    func addDocument<T: Encodable>(_ data: T, into collection: CollectionName) async throws
    func updateDocuments(into collection: CollectionName, where field: String, isEqualTo value: Any, fieldToUpdate: String, newValue: Any) async throws
    func generateDocumentID(for collection: CollectionName) -> String
    func search(into collection: CollectionName, field: String, contains values: [String]) async throws -> [DatabaseDoc]
}

protocol DatabaseDoc {

    func decodedData<T: Decodable>() throws -> T
    var documentID: String { get }
}

enum CollectionName: String {
    case events
    case categories
}

enum DBSorting: String {
    case byDate = "date"
    case byTitle = "title"
}
