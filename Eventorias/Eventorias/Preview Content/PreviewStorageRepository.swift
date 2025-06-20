//
//  PreviewStorageRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 20/06/2025.
//

import Foundation

class PreviewStorageRepository: StorageRepository {

    func putData(_ data: Data, into folder: StorageFolder, fileName: String) async throws -> String {
        return "wwww.preview.com"
    }
    
    func deleteFile(_ fileName: String, from folder: StorageFolder) async throws {}
}
