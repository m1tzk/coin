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
    
    @Relationship(deleteRule: .cascade, inverse: \ExpenseRecord.place)
    
    var visits: [ExpenseRecord] = []
    
    init(name: String, latitude: Double? = nil, longitude: Double? = nil, visits: [ExpenseRecord] = []) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.visits = visits
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
