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

    func fetchDocument(into collection: CollectionName, docID: String) async throws -> DatabaseDoc {
        return try await db.collection(collection.rawValue).document(docID).getDocument()
    }

    func fetchDocuments(into collection: CollectionName) async throws -> [DatabaseDoc] {
        try await db.collection(collection.rawValue).getDocuments().documents
    }

    func fetchUpcomingDoc(into collection: CollectionName, orderBy: DBSorting, where field: String, isIn filters: [String]) async throws -> [DatabaseDoc] {
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

    func updateDocuments(into collection: CollectionName, where field: String, isEqualTo value: Any, fieldToUpdate: String, newValue: Any) async throws {
        let documents = try await db
            .collection(collection.rawValue)
            .whereField(field, isEqualTo: value)
            .getDocuments()
            .documents

        for doc in documents {
            try await doc.reference.updateData([fieldToUpdate: newValue])
        }
    }

    func generateDocumentID(for collection: CollectionName) -> String {
        return db.collection(collection.rawValue).document().documentID
    }

    func search(into collection: CollectionName, field: String, contains values: [String]) async throws -> [DatabaseDoc] {
        try await db
            .collection(collection.rawValue)
            .whereField(field, arrayContainsAny: values)
            .getDocuments()
            .documents
    }
}
