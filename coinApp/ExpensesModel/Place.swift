//
//  Place.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 23/08/2026.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class Place {
    var name: String
    
    var latitude: Double?
    var longitude: Double?
    
    var createdAt: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \ExpenseRecord.place)
    
    var visits: [ExpenseRecord] = []
    
    init(name: String, latitude: Double? = nil, longitude: Double? = nil, visits: [ExpenseRecord] = [], createdAt: Date? = .now) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.visits = visits
        self.createdAt = createdAt
    }
    
    var totalSpent: Decimal {
        visits.reduce(0) { result, visit in
            result + visit.totalSpent
        }
    }
    
    var averageRating: Double? {
        let ratings = visits.compactMap(\.rating)
        guard !ratings.isEmpty else { return nil }
        return (Double(ratings.reduce(0, +)) / Double(ratings.count) * 10).rounded() / 10
    }
    
    var lastVisitedAt: Date? {
        visits.map(\.createdAt).max()
    }
}

extension Place {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Array {
    // случайный элемент работающий при перезапуске
    // одинаковый при перерисовках
    func pseudoRandomElement(seed: some Hashable) -> Element? {
        guard !isEmpty else { return nil }
        let hash = seed.hashValue
        let safeHash = (hash == Int.min) ? 0 : abs(hash)
        let index = safeHash % count
        return self[index]
    }
}
