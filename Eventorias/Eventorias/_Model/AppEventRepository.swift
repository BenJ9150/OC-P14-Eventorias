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
        dbRepo: DatabaseRepository = FirebaseFirestoreRepository(),
        storageRepo: StorageRepository = FirebaseStorageRepository()
    ) {
        self.dbRepo = dbRepo
        self.storageRepo = storageRepo
    }
}

// MARK: Fetch

extension AppEventRepository {

    func fetchEvent(withId eventId: String) async throws -> Event? {
        let document = try await dbRepo.fetchDocument(into: .events, docID: eventId)
        return documentToEvent(document)
    }

    func fetchEvents(orderBy: DBSorting, from categories: [EventCategory]) async throws -> [Event] {
        let categoryIds = categories.map({ $0.id ?? "" })
        let documents = try await dbRepo.fetchUpcomingDoc(into: .events, orderBy: orderBy, where: "category", isIn: categoryIds)
        return documentsToEvent(documents)
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

    func addEvent(_ event: Event, image: UIImage) async throws {
        /// Create Event ID
        let eventId = dbRepo.generateDocumentID(for: .events)

        /// Upload image
        let imageData = try image.jpegData(maxSize: 600)
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
            photoURL: photoUrl,
            title: event.title,
            keywords: event.title.keywords()
        )
        /// Add event
        try await dbRepo.addDocument(finalEvent, into: .events)
    }
}

// MARK: Search

extension AppEventRepository {

    func searchEvents(with query: String) async throws -> [Event] {
        let documents = try await dbRepo.search(into: .events, field: "keywords", contains: query.keywords())
        return documentsToEvent(documents)
    }
}

// MARK: Private

extension AppEventRepository {

    private func documentsToEvent(_ documents: [DatabaseDoc]) -> [Event] {
        return documents.compactMap { document in
            return documentToEvent(document)
        }
    }

    private func documentToEvent(_ document: DatabaseDoc) -> Event? {
        guard var event: Event = try? document.decodedData() else {
            return nil
        }
        event.id = document.documentID
        return event
    }
}
