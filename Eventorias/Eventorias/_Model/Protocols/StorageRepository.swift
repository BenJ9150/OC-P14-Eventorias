//
//  StorageRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/05/2025.
//

import Foundation

protocol StorageRepository {

    func putData(_ data: Data, into folder: StorageFolder, fileName: String) async throws -> String
    func deleteFile(_ fileName: String, from folder: StorageFolder) async throws
}

enum StorageFolder: String {
    case events
    case avatars
}
