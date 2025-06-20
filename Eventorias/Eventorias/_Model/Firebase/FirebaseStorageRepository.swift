//
//  FirebaseStorageRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/05/2025.
//

import Foundation
import FirebaseStorage

class FirebaseStorageRepository: StorageRepository {

    func putData(_ data: Data, into folder: StorageFolder, fileName: String) async throws -> String {
        let dataRef = Storage.storage().reference().child(folder.rawValue + "/" + fileName)
        _ = try await dataRef.putDataAsync(data, metadata: nil)
        return try await dataRef.downloadURL().absoluteString
    }

    func deleteFile(_ fileName: String, from folder: StorageFolder) async throws {
        let fileRef = Storage.storage().reference().child(folder.rawValue + "/" + fileName)
        do {
            try await fileRef.delete()
        } catch let error as NSError {
            /// Error code -13010: file not found, so already deleted
            if error.code != -13010 {
                throw error
            }
        }
    }
}
