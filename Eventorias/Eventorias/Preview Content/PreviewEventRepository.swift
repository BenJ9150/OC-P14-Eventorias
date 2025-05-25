//
//  PreviewEventRepository.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation
import SwiftUI

class PreviewEventRepository {

    // MARK: Init

    private var networkError: Bool

    init(withNetworkError networkError: Bool = false) {
        self.networkError = networkError
    }
}

// MARK: EventRepository protocol

extension PreviewEventRepository: EventRepository {

    func fetchEvents() async throws -> [Event] {
        if networkError {
            throw AppError.networkError
        }
        return previewEvents()
    }
    
    func fetchCategories() async throws -> [EventCategory] {
        if networkError {
            throw AppError.networkError
        }
        /// Try to return decoded data
        return try JSONDecoder().decode([EventCategory].self, from: getData(jsonFile: "EventCategories"))
    }

    func addEvent(_ event: Event, image: UIImage) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if networkError {
            throw AppError.networkError
        }
    }
}

// MARK: Events

extension PreviewEventRepository {

    func previewEvents() -> [Event] {
        /// Set decoder date string format (like json file content)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        /// Try to return decoded data
        let events = try! decoder.decode([Event].self, from: getData(jsonFile: "Events"))

        let imagePortrait = getImagePortraitUrl()
        let imageLandscape = getImageLandscapeUrl()
        let avatar = getImageURL(for: "avatar")

        return events.enumerated().map { index, event in
            let photoURL = index % 2 == 0 ? imagePortrait : imageLandscape
            return Event(
                id: event.id,
                createdBy: event.createdBy,
                avatar: avatar,
                address: event.address,
                category: event.category,
                date: event.date,
                description: event.description,
                photoURL: photoURL,
                title: event.title
            )
        }
    }
}

// MARK: Image

extension PreviewEventRepository {

    func getImagePortraitUrl() -> String {
        getImageURL(for: "PreviewPicturePortrait")
    }

    func getImageLandscapeUrl() -> String {
        getImageURL(for: "PreviewPictureLandscape")
    }
}

// MARK: Private

private extension PreviewEventRepository {

    func getData(jsonFile: String) -> Data {
        /// Get bundle for json localization
        let bundle = Bundle(for: PreviewEventRepository.self)

        /// Create url
        guard let url = bundle.url(forResource: jsonFile, withExtension: "json") else {
            fatalError("Failed to get url of \(jsonFile).json")
        }
        /// Return data
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Failed to decode data of \(jsonFile).json")
        }
    }

    func getImageURL(for imageName: String) -> String {
        /// Get bundle for json localization
        let bundle = Bundle(for: PreviewEventRepository.self)

        /// Create url
        guard let url = bundle.url(forResource: imageName, withExtension: "png") else {
            fatalError("Failed to get url of \(imageName).png")
        }
        return url.absoluteString
    }
}
