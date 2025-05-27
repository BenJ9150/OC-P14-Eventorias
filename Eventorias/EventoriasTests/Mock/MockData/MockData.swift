//
//  MockData.swift
//  EventoriasTests
//
//  Created by Benjamin LEFRANCOIS on 23/05/2025.
//

import Foundation
import SwiftUI
@testable import Eventorias

class MockData {

    func event() -> Event {
        Event(
            createdBy: "xxxxxxxxxxxxx",
            avatar: "",
            address: "67 Parc Solidaire, Stade Municipal, Toulouse, 31000, France",
            category: "charity_volunteering",
            date: .now,
            description: "Participate in our Charity Run to support local NGOs. All participants get a T-shirt and a finisher medal!",
            photoURL: "",
            title: "Charity run"
        )
    }

    func eventCategory() -> EventCategory {
        EventCategory(id: "art_exhibitions", name: "Art & Exhibitions", emoji: "🎨")
    }

    func image() -> UIImage {
        
        return UIImage(named: "ImageTest", in: Bundle(for: MockData.self), with: nil)!
        
        
        
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
