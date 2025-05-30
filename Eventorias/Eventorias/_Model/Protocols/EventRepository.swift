//
//  EventRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
import SwiftUI

protocol EventRepository {

    func fetchEvents(orderBy: DBSorting) async throws -> [Event]
    func fetchCategories() async throws -> [EventCategory]
    func addEvent(_ event: Event, image: UIImage) async throws
    func searchEvents(with query: String) async throws -> [Event]
}
