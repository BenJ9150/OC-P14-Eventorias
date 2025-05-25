//
//  FirestoreRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation
import FirebaseFirestore

class FirestoreRepository: DatabaseRepository {

    func fetchDocuments(into collection: CollectionName) async throws -> [DocumentRepository] {
        try await Firestore.firestore().collection(collection.rawValue).getDocuments().documents
    }

    func addDocument<T: Encodable>(_ data: T, into collection: CollectionName) async throws {
        let encodedData = try Firestore.Encoder().encode(data)
        try await Firestore.firestore().collection(collection.rawValue).document().setData(encodedData)
    }

    func generateDocumentID(for collection: CollectionName) -> String {
        return Firestore.firestore().collection(collection.rawValue).document().documentID
    }
}
