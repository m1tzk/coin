//
//  ExpenceItemDraft.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 13/08/2026.
//

import Foundation

struct ExpenseItemDraft: Identifiable {
    let id = UUID()
    
    var serviceName = ""
    var unitPrice: Decimal = 0
    var quantity = 1
    
    var totalAmount: Decimal {
        -(unitPrice * Decimal(quantity))
    }
    
    var isValid: Bool {
        !serviceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && unitPrice > 0 && quantity > 0
    }
}
