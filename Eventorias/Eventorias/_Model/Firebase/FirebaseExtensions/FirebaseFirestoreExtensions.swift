//
//  FirebaseFirestoreExtensions.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 30/05/2025.
//

import Foundation
import FirebaseFirestore

extension QueryDocumentSnapshot: DocumentRepository {
    func decodedData<T: Decodable>() throws -> T {
        try data(as: T.self)
    }
}
