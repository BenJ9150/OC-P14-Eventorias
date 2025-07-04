//
//  EventRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
import SwiftUI

protocol EventRepository {

    func fetchEvent(withId eventId: String) async throws -> Event?
    func fetchEvents(orderBy: DBSorting, from categories: [EventCategory]) async throws -> [Event]
    func fetchCategories() async throws -> [EventCategory]
    func addEvent(_ event: Event, image: UIImage) async throws
    func searchEvents(with query: String) async throws -> [Event]
    func addParticipant(eventId: String?, userId: String?) async throws
    func removeParticipant(eventId: String?, userId: String?) async throws
}
