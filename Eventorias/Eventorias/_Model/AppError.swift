//
//  AppError.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 21/04/2025.
//

import Foundation

enum AppError: Int {
    case emptyField = 1
    case invalidCredentials = 17004
    case invalidEmailFormat = 17008
    case networkError = 17020
    case unknown

    init(forCode code: Int) {
        self = AppError(rawValue: code) ?? .unknown
    }

    var userMessage: String {
        switch self {
        case .emptyField: return "This field is required."
        case .invalidCredentials: return "Incorrect email or password"
        case .invalidEmailFormat: return "Please enter a valid email address"
        case .networkError: return "A network error occurred. Please check your internet connection and try again"
        case .unknown: return "An error has occured, please try again later"
        }
    }
}
