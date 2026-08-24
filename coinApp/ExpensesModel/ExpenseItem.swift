//
//  ExpenceItem.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 10/08/2026.
//

import Foundation
import SwiftData

@Model
final class ExpenseItem {
    var serviceName: String
    var quantity: Int
    var unitPrice: Decimal
    
    var record: ExpenseRecord?
    
    init(serviceName: String, quantity: Int, unitPrice: Decimal) {
        self.serviceName = serviceName
        self.quantity = quantity
        self.unitPrice = unitPrice
    }
    
    var totalAmount: Decimal {
        -(unitPrice * Decimal(quantity))
    }
}
