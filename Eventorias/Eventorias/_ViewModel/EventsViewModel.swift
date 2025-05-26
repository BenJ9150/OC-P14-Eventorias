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
    @Published var addEventCategory: EventCategory
    @Published var addEventCategoryErr = ""
    @Published var addEventDesc = ""
    @Published var addEventDescErr = ""
    @Published var addEventTitle = ""
    @Published var addEventTitleErr = ""

    @Published var addEventDate: Date?
    @Published var addEventDateErr = ""
    @Published var addEventTimeErr = ""

    @Published var addEventPhoto: UIImage?

    let selectCategory = EventCategory(
        id: "select_category",
        name: "Select a category",
        emoji: ""
    )

    // Calendar

    @Published var calendarEventsSelection: [Event]?

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
        self.addEventCategory = selectCategory
    }
}

// MARK: Fetch events

extension EventsViewModel {

    func fetchData() async {
        fetchEventsError = ""
        fetchingEvents = true
        defer { fetchingEvents = false }

        do {
            /// Categories
            categories = try await eventRepo.fetchCategories()
            categories.insert(selectCategory, at: 0)

            /// Events
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
        guard let addEventForm = await checkAddEventFormValidity(byUser: user) else {
            return false
        }
        /// Loading
        addingEvent = true
        defer { addingEvent = false }

        do {
            try await eventRepo.addEvent(
                Event(
                    createdBy: addEventForm.user.uid,
                    avatar: addEventForm.user.photoURL?.absoluteString ?? "",
                    address: addEventAddress,
                    category: addEventForm.categoryId,
                    date: addEventForm.date,
                    description: addEventDesc,
                    photoURL: "",
                    title: addEventTitle
                ),
                image: addEventForm.image
            )
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

    private func checkAddEventFormValidity(byUser user: AuthUser?) async -> AddEventForm? {
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
        /// Check category
        guard let categoryId = addEventCategory.id, categoryId != selectCategory.id else {
            addEventCategoryErr = AppError.emptyField.userMessage
            return nil
        }
        /// Check if there is a photo
        guard let eventImage = addEventPhoto else {
            addEventError = AppError.emptyImage.userMessage
            return nil
        }
        /// Return form data
        return AddEventForm(
            user: currentUser,
            date: eventDate,
            categoryId: categoryId,
            image: eventImage
        )
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
