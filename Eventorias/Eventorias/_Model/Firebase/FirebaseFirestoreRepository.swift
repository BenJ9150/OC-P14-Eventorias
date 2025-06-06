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

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository] {
        try await db.collection(collection.rawValue).getDocuments().documents
    }

    func fetchUpcomingDoc(into collection: CollectionName, orderBy: DBSorting, where field: String, isIn filters: [String]) async throws -> [DocumentRepository] {
        var query = db
            .collection(collection.rawValue)
            /// greater than yesterday
            .whereField(DBSorting.byDate.rawValue, isGreaterThan: Timestamp(date: Date().addingTimeInterval(-86400)))

        if !field.isEmpty && !filters.isEmpty {
            query = query.whereField(field, in: filters)
        }
        query = query.order(by: orderBy.rawValue)
        return try await query.getDocuments().documents
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
