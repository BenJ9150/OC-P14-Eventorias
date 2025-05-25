//
//  FirebaseStorageRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/05/2025.
//

import Foundation
import FirebaseStorage

class FirebaseStorageRepository: StorageRepository {

    func putData(_ data: Data, into folder: StorageFolder, fileName: String) async throws -> URL {
        let dataRef = Storage.storage().reference().child(folder.rawValue + "/" + fileName)
        _ = try await dataRef.putDataAsync(data, metadata: nil)
        return try await dataRef.downloadURL()
    }
}
