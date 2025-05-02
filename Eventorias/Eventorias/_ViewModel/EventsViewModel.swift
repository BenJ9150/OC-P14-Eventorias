//
//  EventsViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

@MainActor class EventsViewModel: ObservableObject {

    @Published var events: [Event] = []
    @Published var categories: [EventCategory] = []
    @Published var fetchingEvents = true
    @Published var fetchEventsError = ""

    // MARK: Private properties

    private let eventRepo: EventRepository

    // MARK: Init

    init(eventRepo: EventRepository = EventService()) {
        self.eventRepo = eventRepo
    }
}

// MARK: Fetch events

extension EventsViewModel {

    func fetchData() async {
        fetchEventsError = ""
        fetchingEvents = true
        defer { fetchingEvents = false }

        do {
            categories = try await eventRepo.fetchCategories()
            events = try await eventRepo.fetchEvents()

        } catch let nsError as NSError {
            print("💥 Fetch events error \(nsError.code): \(nsError.localizedDescription)")
            fetchEventsError = AppError(forCode: nsError.code).userMessage
        }
    }
}
