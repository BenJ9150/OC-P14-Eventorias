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

    @Published var addEventDate: Date?
    @Published var addEventDateErr = ""
    @Published var addEventTimeErr = ""

    @Published var addEventPhotoUrl = ""

    // Calendar

    @Published var calendarEventsSelection: [Event]?

    // MARK: Private properties

    private let eventRepo: EventRepository

    // MARK: Init

    init(eventRepo: EventRepository = AppEventRepository()) {
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

    func addEvent(byUser user: AuthUser?) async -> Bool {
        guard let formValidity = checkAddEventFormValidity(byUser: user) else {
            return false
        }
        /// Loading
        addingEvent = true
        defer { addingEvent = false }

        /// Create event
        let newEvent = Event(
            createdBy: formValidity.user.uid,
            avatar: formValidity.user.photoURL?.absoluteString ?? "",
            address: addEventAddress,
            category: addEventCategory,
            date: formValidity.date,
            description: addEventDesc,
            photoURL: addEventPhotoUrl,
            title: addEventTitle
        )
        do {
            try await eventRepo.addEvent(newEvent)

        } catch let nsError as NSError {
            print("💥 Add event error \(nsError.code): \(nsError.localizedDescription)")
            addEventError = AppError(forCode: nsError.code).userMessage
            return false
        }

        /// Success! Fetch events to update current list
        await fetchData()
        return true
    }

    private func checkAddEventFormValidity(byUser user: AuthUser?) -> (user: AuthUser, date: Date)? {
        /// Clean old error
        cleanAddEventErrors()

        /// Check user
        guard let currentUser = user else {
            addEventError = AppError.currentUserNotFound.userMessage
            return nil
        }
        /// Check empty fields
        var isValid = true
        if addEventTitle.isEmpty {
            addEventTitleErr = AppError.emptyField.userMessage
            isValid = false
        }
        if addEventDesc.isEmpty {
            addEventDescErr = AppError.emptyField.userMessage
            isValid = false
        }
        if addEventAddress.isEmpty {
            addEventAddressErr = AppError.emptyField.userMessage
            isValid = false
        }
        /// Check date of event
        guard let eventDate = addEventDate else {
            addEventDateErr = AppError.emptyField.userMessage
            addEventTimeErr = AppError.emptyField.userMessage
            return nil
        }
        /// Return user and event date if all is valid
        guard isValid else {
            return nil
        }
        return (currentUser, eventDate)
    }

    private func cleanAddEventErrors() {
        addEventError.removeAll()
        addEventDateErr.removeAll()
        addEventTimeErr.removeAll()
        addEventTitleErr.removeAll()
        addEventDescErr.removeAll()
        addEventAddressErr.removeAll()
    }
}
