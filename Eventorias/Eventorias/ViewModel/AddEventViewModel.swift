//
//  AddEventViewModel.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 30/05/2025.
//

import SwiftUI
import MapKit

@MainActor class AddEventViewModel: ObservableObject {

    // MARK: Public properties

    @Published var addingEvent = false
    @Published var addEventError = ""

    @Published var addEventAddress = ""
    @Published var addEventAddressErr = ""
    @Published var addEventCategory = EventCategory.categoryPlaceholder
    @Published var addEventCategoryErr = ""
    @Published var addEventDesc = ""
    @Published var addEventDescErr = ""
    @Published var addEventTitle = ""
    @Published var addEventTitleErr = ""

    @Published var addEventDate: Date?
    @Published var addEventDateErr = ""
    @Published var addEventTimeErr = ""

    @Published var addEventPhoto: UIImage?

    let categories: [EventCategory]

    // MARK: Private properties

    private struct AddEventForm {
        let user: AuthUser
        let date: Date
        let categoryId: String
        let image: UIImage
    }

    private let eventRepo: EventRepository

    // MARK: Init

    init(eventRepo: EventRepository, categories: [EventCategory]) {
#if DEBUG
        self.eventRepo = AppFlags.isTesting ? PreviewEventRepository() : eventRepo
#else
        self.eventRepo = eventRepo
#endif
        self.categories = categories
    }
}

// MARK: Add event

extension AddEventViewModel {

    func addEvent(byUser user: AuthUser?) async -> Bool {
        /// Clean old error
        cleanAddEventErrors()

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
                    avatar: addEventForm.user.avatarURL?.absoluteString ?? "",
                    address: addEventAddress,
                    category: addEventForm.categoryId,
                    date: addEventForm.date,
                    description: addEventDesc,
                    title: addEventTitle
                ),
                image: addEventForm.image
            )
        } catch let nsError as NSError {
            print("💥 Add event error \(nsError.code): \(nsError.localizedDescription)")
            addEventError = AppError(forCode: nsError.code).userMessage
            return false
        }
        return true
    }
}

// MARK: Private

extension AddEventViewModel {

    private func checkAddEventFormValidity(byUser user: AuthUser?) async -> AddEventForm? {
        /// Check empty field
        guard let dateAndCat = fieldsNotEmpty() else {
            return nil
        }
        /// Check user
        guard let currentUser = user else {
            addEventError = AppError.currentUserNotFound.userMessage
            return nil
        }
        /// Check if address is valid
        do {
            _ = try await CLGeocoder().coordinate(for: addEventAddress)
        } catch {
            addEventAddressErr = AppError.invalidAddress.userMessage
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
            date: dateAndCat.date,
            categoryId: dateAndCat.categoryId,
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
        addEventCategoryErr.removeAll()
    }

    private func fieldsNotEmpty() -> (date: Date, categoryId: String)? {
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
        if addEventDate == nil {
            addEventDateErr = AppError.emptyField.userMessage
            addEventTimeErr = AppError.emptyField.userMessage
            notEmpty = false
        }
        if addEventCategory.id == EventCategory.categoryPlaceholder.id {
            addEventCategoryErr = AppError.emptyField.userMessage
            notEmpty = false
        }
        if notEmpty, let date = addEventDate, let cat = addEventCategory.id {
            return (date, cat)
        }
        return nil
    }
}
