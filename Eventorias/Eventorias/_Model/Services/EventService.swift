//
//  EventService.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

class EventService: EventRepository {
    
    private let dbRepo: DatabaseRepository
    
    init(dbRepo: DatabaseRepository = FirestoreRepository()) {
        self.dbRepo = dbRepo
    }
}

// MARK: Fetch

extension EventService {

    func fetchEvents() async throws -> [Event] {
        let documents = try await dbRepo.fetchDocuments(into: CollectionName.events)
        
        return documents.compactMap { document in
            guard var event: Event = try? document.decodedData() else {
                return nil
            }
            event.id = document.documentID
            return event
        }
    }

    func fetchCategories() async throws -> [EventCategory] {
        let documents = try await dbRepo.fetchDocuments(into: CollectionName.categories)
        
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

extension EventService {

    func addEvent(_ event: Event) async throws {
        try await dbRepo.addDocument(event, into: CollectionName.events)
    }
}
