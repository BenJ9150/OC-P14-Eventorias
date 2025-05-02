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

    private let eventService: EventService

    // MARK: Init

    init(eventService: EventService = EventService()) {
        self.eventService = eventService
    }
}

// MARK: Fetch events

extension EventsViewModel {

    func fetchData() async {
        fetchEventsError = ""
        fetchingEvents = true
        defer { fetchingEvents = false }

        do {
            categories = try await eventService.fetchEventCategories()
            events = try await eventService.fetchEvents()

        } catch let nsError as NSError {
            print("💥 Fetch events error \(nsError.code): \(nsError.localizedDescription)")
            fetchEventsError = AppError(forCode: nsError.code).userMessage
        }
    }
}
