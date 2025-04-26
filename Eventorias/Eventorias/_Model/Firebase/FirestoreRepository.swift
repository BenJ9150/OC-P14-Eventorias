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
}
