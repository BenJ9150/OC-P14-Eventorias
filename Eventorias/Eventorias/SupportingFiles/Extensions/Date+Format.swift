//
//  Date+Format.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import Foundation

extension Date {

    func toMonthDayYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }

    func toHourMinuteAMPM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }

    func toMonthDayYearSlashes() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }

    func toHourMinute24h() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH : mm"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
}
