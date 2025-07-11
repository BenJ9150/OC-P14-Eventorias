//
//  FirebaseFirestoreRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation
import FirebaseFirestore

class FirebaseFirestoreRepository: DatabaseRepository {

    // MARK: Fetch

    func fetchDocument(into collection: CollectionName, docID: String) async throws -> DatabaseDoc {
        return try await Firestore.firestore().collection(collection.rawValue).document(docID).getDocument()
    }

    func fetchDocuments(into collection: CollectionName) async throws -> [DatabaseDoc] {
        try await Firestore.firestore().collection(collection.rawValue).getDocuments().documents
    }

    func fetchUpcomingDoc(into collection: CollectionName, orderBy: DBSorting, where field: String, isIn filters: [String]) async throws -> [DatabaseDoc] {
        var query = Firestore.firestore()
            .collection(collection.rawValue)
            /// greater than yesterday
            .whereField(DBSorting.byDate.rawValue, isGreaterThan: Timestamp(date: Date().addingTimeInterval(-86400)))

        if !field.isEmpty && !filters.isEmpty {
            query = query.whereField(field, in: filters)
        }
        query = query.order(by: orderBy.rawValue)
        return try await query.getDocuments().documents
    }

    // MARK: Add

    func generateDocumentID(for collection: CollectionName) -> String {
        return Firestore.firestore().collection(collection.rawValue).document().documentID
    }

    func addDocument<T: Encodable>(_ data: T, withID documentID: String, into collection: CollectionName) async throws {
        let encodedData = try Firestore.Encoder().encode(data)
        try await Firestore.firestore().collection(collection.rawValue).document(documentID).setData(encodedData)
    }

    // MARK: Update

    func updateDocuments(into collection: CollectionName, where field: String, isEqualTo value: Any, fieldToUpdate: String, newValue: Any) async throws {
        let documents = try await Firestore.firestore()
            .collection(collection.rawValue)
            .whereField(field, isEqualTo: value)
            .getDocuments()
            .documents

        for doc in documents {
            try await doc.reference.updateData([fieldToUpdate: newValue])
        }
    }

    func updateDocuments(into collection: CollectionName, withID documentID: String?, arrayToUpdate: String, addValue: Any?) async throws {
        guard let docID = documentID, let value = addValue else {
            throw AppError.unknown
        }
        try await Firestore.firestore()
            .collection(collection.rawValue)
            .document(docID)
            .updateData([arrayToUpdate: FieldValue.arrayUnion([value])])
    }

    func updateDocuments(into collection: CollectionName, withID documentID: String?, arrayToUpdate: String, removeValue: Any?) async throws {
        guard let docID = documentID, let value = removeValue else {
            throw AppError.unknown
        }
        try await Firestore.firestore()
            .collection(collection.rawValue)
            .document(docID)
            .updateData([arrayToUpdate: FieldValue.arrayRemove([value])])
    }

    // MARK: Search

    func search(into collection: CollectionName, field: String, contains values: [String]) async throws -> [DatabaseDoc] {
        try await Firestore.firestore()
            .collection(collection.rawValue)
            .whereField(field, arrayContainsAny: values)
            .getDocuments()
            .documents
    }
}
