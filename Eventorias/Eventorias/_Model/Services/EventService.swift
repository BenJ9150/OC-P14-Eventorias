//
//  EventService.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 26/04/2025.
//

import Foundation

class EventService {

    private let dbRepo: DatabaseRepository

    init(dbRepo: DatabaseRepository = FirestoreRepository()) {
        self.dbRepo = dbRepo
    }

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

    func fetchEventCategories() async throws -> [EventCategory] {
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
