//
//  MockStorageRepository.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 27/05/2025.
//

import Foundation
@testable import Eventorias

class MockStorageRepository: StorageRepository {

    func putData(_ data: Data, into folder: StorageFolder, fileName: String) async throws -> URL {
        return URL(string: "www.test.com")!
    }
}
