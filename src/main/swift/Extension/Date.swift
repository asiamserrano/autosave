//
//  Date.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

fileprivate enum DateEnum: String {
    case dashes = "yyyy-MM-dd"
    case dashless = "yyyyMMdd"
    case long = "MMMM d, y"
    case year = "yyyy"
    case timestamp = "yyyyMMdd-hhmmssa"
}

fileprivate extension DateFormatter {
    
    static func create(_ dateString: String) -> Date {
        DateFormatter(formatString: DateEnum.dashless.rawValue).date(from: dateString)!
    }
    
    static func format(_ date: Date, _ form: DateEnum) -> String {
        DateFormatter(formatString: form.rawValue).string(from: date)
    }
    
    private convenience init(formatString: String) {
        self.init()
        self.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        self.dateFormat = formatString
    }
    
}

public extension Date {
    
    static var defaultValue: Self {
        .fromDate(.now)
    }
    
    static func fromString(_ dashless: String) -> Self {
        return DateFormatter.create(dashless)
    }
    
    static func fromDate(_ other: Self) -> Self {
        return .fromString(other.dashless)
    }
    
    static func fromDateComponents(_ year: Int, _ month: Int, _ day: Int) -> Self {
        let month_str: String = month.leadingZero
        let day_str: String = day.leadingZero
        let dashless: String = "\(year)\(month_str)\(day_str)"
        return .fromString(dashless)
    }
    
    static var random: Self {
        let low: TimeInterval = Self.fromDateComponents(1900,1,1).timeIntervalSinceNow
        let high: TimeInterval = Self.now.timeIntervalSinceNow
        let time: TimeInterval = TimeInterval.random(in: low...high)
        return .init(timeIntervalSinceReferenceDate: time)
    }
    
    var long: String {
        DateFormatter.format(self, .long)
    }
    
    var dashless: String {
        DateFormatter.format(self, .dashless)
    }

    var year: String {
        DateFormatter.format(self, .year)
    }

    var dashes: String {
        DateFormatter.format(self, .dashes)
    }

}
