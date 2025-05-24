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
    @Published var addEventPhoto: Image?

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
        /// Clean old error
        cleanAddEventErrors()

        /// Check data
        guard fieldsNotEmpty() else {
            return false
        }
        guard let formValidity = await checkAddEventFormValidity(byUser: user) else {
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

    private func fieldsNotEmpty() -> Bool {
        var notEmpty = true

        if addEventTitle.isEmpty {
            addEventTitleErr = AppError.emptyField.userMessage
            notEmpty = false
        }
        if addEventDesc.isEmpty {
            addEventDescErr = AppError.emptyField.userMessage
            notEmpty = false
        }
        if addEventAddress.isEmpty {
            addEventAddressErr = AppError.emptyField.userMessage
            notEmpty = false
        }
        return notEmpty
    }

    private func checkAddEventFormValidity(byUser user: AuthUser?) async -> (user: AuthUser, date: Date)? {
        /// Check user
        guard let currentUser = user else {
            addEventError = AppError.currentUserNotFound.userMessage
            return nil
        }
        /// Check date of event
        guard let eventDate = addEventDate else {
            addEventDateErr = AppError.emptyField.userMessage
            addEventTimeErr = AppError.emptyField.userMessage
            return nil
        }
        /// Check if address is valid
        do {
            _ = try await CLGeocoder().coordinate(for: addEventAddress)
        } catch {
            addEventAddressErr = AppError.invalidAddress.userMessage
            return nil
        }
        /// Return user and event date
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
