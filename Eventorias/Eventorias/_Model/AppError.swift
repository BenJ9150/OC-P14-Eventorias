//
//  AppError.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 21/04/2025.
//

import Foundation

enum AppError: Int, Error {
    case emptyField
    case invalidCredentials = 17004
    case emailAlreadyInUse = 17007
    case invalidEmailFormat = 17008
    case emailUpdateNeedAuth = 17014
    case networkError = 17020
    case weakPassword = 17026
    case currentUserNotFound
    case invalidAddress
    case emptyImage
    case invalidImage
    case searchEventIsEmpty
    case unknown

    init(forCode code: Int) {
        self = AppError(rawValue: code) ?? .unknown
    }

    var userMessage: String {
        switch self {
        case .emptyField: return "This field is required."
        case .invalidCredentials: return "Incorrect email or password"
        case .emailAlreadyInUse: return "This email is already linked to an account"
        case .invalidEmailFormat: return "Please enter a valid email address"
        case .emailUpdateNeedAuth: return "This operation requires recent authentication. Please sign out and log in again before trying to update your email"
        case .networkError: return "A network error occurred. Please check your internet connection and try again"
        case .weakPassword: return "Password must have at least 8 characters, an uppercase letter, a number, and a special character"
        case .currentUserNotFound: return "User could not be found"
        case .invalidAddress: return "Incorrect address"
        case .emptyImage: return "Please choose an image"
        case .invalidImage: return "Invalid image. Please choose another one."
        case .searchEventIsEmpty: return "No event found, try another search"
        case .unknown: return "An error has occured, please try again later"
        }
    }
}
