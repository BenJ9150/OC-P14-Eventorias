//
//  FirebaseFirestoreRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation
import FirebaseFirestore

class FirebaseFirestoreRepository: DatabaseRepository {

    private let db = Firestore.firestore()

    func fetchUpcomingDocuments(into collection: CollectionName, orderBy: DBSorting) async throws -> [DocumentRepository] {
        try await db.collection(collection.rawValue)
            .whereField(DBSorting.byDate.rawValue, isGreaterThan: Timestamp(date: Date().addingTimeInterval(-86400))) // greater than yesterday
            .order(by: orderBy.rawValue)
            .getDocuments().documents
    }

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository] {
        try await db.collection(collection.rawValue).getDocuments().documents
    }

    func addDocument<T: Encodable>(_ data: T, into collection: CollectionName) async throws {
        let encodedData = try Firestore.Encoder().encode(data)
        try await db.collection(collection.rawValue).document().setData(encodedData)
    }

    func generateDocumentID(for collection: CollectionName) -> String {
        return db.collection(collection.rawValue).document().documentID
    }

    func search(into collection: CollectionName, field: String, contains values: [String]) async throws -> [DocumentRepository] {
        try await db
            .collection(collection.rawValue)
            .whereField(field, arrayContainsAny: values)
            .getDocuments()
            .documents
    }
}
