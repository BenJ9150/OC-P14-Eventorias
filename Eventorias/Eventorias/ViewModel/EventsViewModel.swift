//
//  EventsViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI
import MapKit

@MainActor class EventsViewModel: ObservableObject {

    // MARK: Public properties

    // Fetch events

    @Published var events: [Event] = []
    @Published var categories: [EventCategory] = []
    @Published var fetchingEvents = true
    @Published var fetchEventsError = ""

    // Calendar

    @Published var calendarEventsSelection: [Event]?

    // Search

    @Published var userIsSearching = false
    @Published var search = ""
    @Published var searchResult: [Event] = []
    @Published var fetchingSearchedEvents = false
    @Published var searchEventsError = ""

    // Sorting

    @Published var eventSorting: DBSorting = .byTitle
    @Published var categoriesSelection: [EventCategory] = []

    // Share event

    @Published var eventFromShare: Event?

    // Participants

    @Published private(set) var toggleParticipate = false
    @Published var updatingParticipant = false
    @Published var toggleParticipateError = ""

    // MARK: Private properties

    private struct AddEventForm {
        let user: AuthUser
        let date: Date
        let categoryId: String
        let image: UIImage
    }

    private let eventRepo: EventRepository

    // MARK: Init

    init(eventRepo: EventRepository = AppEventRepository()) {
#if DEBUG
        self.eventRepo = AppFlags.isTesting ? PreviewEventRepository() : eventRepo
#else
        self.eventRepo = eventRepo
#endif
    }
}

// MARK: Fetch events

extension EventsViewModel {

    func fetchData() async {
        fetchEventsError.removeAll()
        fetchingEvents = true
        defer { fetchingEvents = false }

        do {
            /// Categories
            if categories.isEmpty {
                categories = try await eventRepo.fetchCategories()
                categories.insert(EventCategory.categoryPlaceholder, at: 0)
            }

            /// Events
            events = try await eventRepo.fetchEvents(orderBy: eventSorting, from: categoriesSelection)

        } catch let nsError as NSError {
            print("💥 Fetch events error \(nsError.code): \(nsError.localizedDescription)")
            fetchEventsError = AppError(forCode: nsError.code).userMessage
        }
    }
}

// MARK: Search events

extension EventsViewModel {

    func searchEvents() async {
        if search.isEmpty {
            return
        }
        searchEventsError.removeAll()
        userIsSearching = true
        fetchingSearchedEvents = true
        defer { fetchingSearchedEvents = false }

        do {
            searchResult = try await eventRepo.searchEvents(with: search)
            if searchResult.isEmpty {
                searchEventsError = AppError.searchEventIsEmpty.userMessage
            }

        } catch let nsError as NSError {
            print("💥 Search events error \(nsError.code): \(nsError.localizedDescription)")
            searchEventsError = AppError(forCode: nsError.code).userMessage
        }
    }

    func clearSearch() {
        search.removeAll()
        searchEventsError.removeAll()
        searchResult.removeAll()
        userIsSearching = false
    }
}

// MARK: Show event from URL

extension EventsViewModel {
    
    func showEvent(from url: URL) async throws {
        /// Get event id from url
        guard url.scheme == Event.shareUrlScheme,
              url.host == Event.shareUrlHost else {
            return
        }
        /// Fetch event with its id
        eventFromShare = try await eventRepo.fetchEvent(withId: url.lastPathComponent)
    }
}

// MARK: Participants

extension EventsViewModel {

    func setParticipation(to event: Event, user: AuthUser?) {
        if let userId = user?.uid {
            toggleParticipate = event.participants.contains(userId)
        }
    }

    func toggleParticipation(to value: Bool, event: Event, user: AuthUser?) async {
        let lastState = toggleParticipate
        toggleParticipateError.removeAll()
        toggleParticipate = value

        updatingParticipant = true
        defer { updatingParticipant = false }
        do {
            if toggleParticipate {
                /// User wants to participate
                try await eventRepo.addParticipant(eventId: event.id, userId: user?.uid)
            } else {
                /// User no longer wants to participate
                try await eventRepo.removeParticipant(eventId: event.id, userId: user?.uid)
            }
        } catch let nsError as NSError {
            print("💥 Toggle participation error \(nsError.code): \(nsError.localizedDescription)")
            toggleParticipateError = AppError(forCode: nsError.code).userMessage
            toggleParticipate = lastState
        }
        /// Refresh events
        await fetchData()
    }
}
