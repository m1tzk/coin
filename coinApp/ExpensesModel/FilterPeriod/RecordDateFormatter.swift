//
//  RecordDateFormatter.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 27/08/2026.
//

import Foundation

enum RecordDateFormatter {
    static func time(_ date: Date) -> String {
        date.formatted(.dateTime.hour().minute())
    }
    
    static func dayMonthTime(_ date: Date) -> String {
        capitalize(date.formatted(dayMonthTimeStyle))
    }
    
    static func full(_ date: Date) -> String {
        capitalize(date.formatted(fullStyle))
    }
    
    private static let dayMonthTimeStyle = Date.VerbatimFormatStyle(
        format: "\(day: .defaultDigits) \(month: .wide), \(hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .oneBased)):\(minute: .twoDigits)",
        locale: .autoupdatingCurrent,
        timeZone: .current,
        calendar: .current)
    
    private static let fullStyle = Date.VerbatimFormatStyle(
        format: "\(day: .defaultDigits) \(month: .wide), \(year: .defaultDigits), \(hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .oneBased)):\(minute: .twoDigits)",
        locale: .autoupdatingCurrent,
        timeZone: .current,
        calendar: .current)
    
    private static func capitalize(_ string: String) -> String {
        string.prefix(1).uppercased() + string.dropFirst()
    }
}

extension RecordDateFormatter {
    static func chartAxisDate(_ date: Date, period: FilterPeriod) -> String {
        switch period {
        case .today:
            return time(date)
        case .week, .month:
            return dayMonthTime(date)
        case .all:
            return full(date)
        }
    }
}
