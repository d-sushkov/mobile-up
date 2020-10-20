//
//  Date+Format.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import Foundation

extension Date {
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func formatRelativeString() -> String {
        let calendar = Calendar(identifier: .gregorian)

        if calendar.isDateInToday(self) {
            Date.formatter.timeStyle = .short
            Date.formatter.dateStyle = .none
        } else if calendar.isDateInYesterday(self){
            Date.formatter.timeStyle = .none
            Date.formatter.dateStyle = .medium
        } else if calendar.compare(Date(), to: self, toGranularity: .weekOfYear) == .orderedSame {
            let weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
            return Date.formatter.weekdaySymbols[weekday-1]
        } else {
            Date.formatter.timeStyle = .none
            Date.formatter.dateStyle = .short
        }
        return Date.formatter.string(from: self)
    }
}
