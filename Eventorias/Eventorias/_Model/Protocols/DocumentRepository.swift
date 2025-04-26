//
//  DocumentRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

protocol DocumentRepository {
    func decodedData<T: Decodable>() throws -> T
    var documentID: String { get }
}
