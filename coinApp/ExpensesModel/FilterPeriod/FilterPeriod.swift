//
//  FilterPeriod.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 23/08/2026.
//
import Foundation

enum FilterPeriod: String, CaseIterable, Hashable {
     case today
     case week
     case month
     case all
 }

extension FilterPeriod: Identifiable {
    var id: Self { self }
}

extension FilterPeriod {
    var filterValue: String {
        switch self {
        case .all: "Все время"
        case .month: "Месяц"
        case .week: "Неделя"
        case .today: "Сегодня"
        }
    }
    
    func contains(_ date: Date, calendar: Calendar = .current) -> Bool {
        switch self {
        case .all:
            return true
        case .month:
            guard let interval = calendar.dateInterval(of: .month, for: .now) else { return false }
            return interval.contains(date)
        case .week:
            guard let interval = calendar.dateInterval(of: .weekOfYear, for: .now) else { return false }
            return interval.contains(date)
        case .today:
            return calendar.isDateInToday(date)
        }
    }
}
