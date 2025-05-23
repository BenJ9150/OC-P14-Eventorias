//
//  EventRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation

protocol EventRepository {
    func fetchEvents() async throws -> [Event]
    func fetchCategories() async throws -> [EventCategory]
    func addEvent(_ event: Event) async throws
}
