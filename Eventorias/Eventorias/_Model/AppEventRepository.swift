//
//  AppEventRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation
import SwiftUI

class AppEventRepository: EventRepository {
    
    private let dbRepo: DatabaseRepository
    private let storageRepo: StorageRepository
    
    init(
        dbRepo: DatabaseRepository = FirestoreRepository(),
        storageRepo: StorageRepository = FirebaseStorageRepository()
    ) {
        self.dbRepo = dbRepo
        self.storageRepo = storageRepo
    }
}

// MARK: Fetch

extension AppEventRepository {

    func fetchEvents() async throws -> [Event] {
        let documents = try await dbRepo.fetchDocuments(into: .events)
        
        return documents.compactMap { document in
            guard var event: Event = try? document.decodedData() else {
                return nil
            }
            event.id = document.documentID
            return event
        }
    }

    func fetchCategories() async throws -> [EventCategory] {
        let documents = try await dbRepo.fetchDocuments(into: .categories)
        
        return documents.compactMap { document in
            guard var category: EventCategory = try? document.decodedData() else {
                return nil
            }
            category.id = document.documentID
            return category
        }
    }
}

// MARK: Add

extension AppEventRepository {

    func addEvent(title: String, desc: String, date: Date, address: String, category: String, author: AuthUser, image: UIImage) async throws {
        /// Create Event ID
        let eventId = dbRepo.generateDocumentID(for: .events)

        /// Upload image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AppError.invalidImage
        }
        let photoUrl = try await storageRepo.putData(imageData, into: .events, fileName: "\(eventId).jpg")

        /// Create Event
        let event = Event(
            id: eventId,
            createdBy: author.uid,
            avatar: author.photoURL?.absoluteString ?? "",
            address: address,
            category: category,
            date: date,
            description: desc,
            photoURL: photoUrl.absoluteString,
            title: title
        )
        /// Add event
        try await dbRepo.addDocument(event, into: .events)
    }

    func addEvent(_ event: Event, image: UIImage) async throws {
        /// Create Event ID
        let eventId = dbRepo.generateDocumentID(for: .events)

        /// Upload image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AppError.invalidImage
        }
        let photoUrl = try await storageRepo.putData(imageData, into: .events, fileName: "\(eventId).jpg")

        /// Update Event
        let finalEvent = Event(
            id: eventId,
            createdBy: event.createdBy,
            avatar: event.avatar,
            address: event.address,
            category: event.category,
            date: event.date,
            description: event.description,
            photoURL: photoUrl.absoluteString,
            title: event.title
        )
        /// Add event
        try await dbRepo.addDocument(finalEvent, into: .events)
    }
}
