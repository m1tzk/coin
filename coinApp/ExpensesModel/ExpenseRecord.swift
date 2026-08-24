//
//  ExpenseRecord.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 10/08/2026.
//

import Foundation
import SwiftUI
import SwiftData
import CoreLocation

@Model
final class ExpenseRecord {
    var currencyCode: String
    var createdAt: Date
    var rating: Int?
    
    @Relationship(deleteRule: .cascade, inverse: \ExpenseItem.record)
    var items: [ExpenseItem]
    
    @Relationship(deleteRule: .cascade, inverse: \ExpensePhoto.record)
    var photos: [ExpensePhoto]
    
    var place: Place?
    
    init/*?*/ (currencyCode: String, rating: Int? = nil, items: [ExpenseItem] = [], photos: [ExpensePhoto] = [], place: Place? = nil) {
//        if (placeName.isEmpty || currencyCode.isEmpty) {
//            return nil
//        }
        self.currencyCode = currencyCode
        self.createdAt = Date()
        self.rating = rating
        self.items = items
        self.photos = photos
        self.place = place
    }
    
    var totalSpent: Decimal {
        items.reduce(0) { partialResult, item in
            partialResult + item.totalAmount
        }
    }
}


