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
        self.eventRepo = eventRepo
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
