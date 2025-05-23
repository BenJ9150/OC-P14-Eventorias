//
//  EventsViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

@MainActor class EventsViewModel: ObservableObject {

    // MARK: Public properties

    // Fetch events

    @Published var events: [Event] = []
    @Published var categories: [EventCategory] = []
    @Published var fetchingEvents = true
    @Published var fetchEventsError = ""
    @Published var search = ""

    // Add event

    @Published var addingEvent = false
    @Published var addEventError = ""

    @Published var addEventAddress = ""
    @Published var addEventAddressErr = ""
    @Published var addEventCategory = ""
    @Published var addEventCategoryErr = ""
    @Published var addEventDesc = ""
    @Published var addEventDescErr = ""
    @Published var addEventTitle = ""
    @Published var addEventTitleErr = ""

    @Published var addEventDate = Date()
    @Published var addEventDateErr = ""
    @Published var addEventTimeErr = ""

    @Published var addEventPhotoUrl = ""

    // Calendar

    @Published var calendarEventsSelection: [Event]?

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

// MARK: Add event

extension EventsViewModel {

    func addEvent(byUser user: AuthUser?) async {
        guard let currentUser = user else {
            return
        }
        addEventError = ""
        addingEvent = true
        defer { addingEvent = false }

        let newEvent = Event(
            createdBy: currentUser.uid,
            avatar: currentUser.photoURL?.absoluteString ?? "",
            address: addEventAddress,
            category: addEventCategory,
            date: addEventDate,
            description: addEventDesc,
            photoURL: addEventPhotoUrl,
            title: addEventTitle
        )
        do {
            try await eventRepo.addEvent(newEvent)

        } catch let nsError as NSError {
            print("💥 Add event error \(nsError.code): \(nsError.localizedDescription)")
            addEventError = AppError(forCode: nsError.code).userMessage
        }
    }
}
