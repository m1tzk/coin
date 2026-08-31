//
//  AppRouter.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 31/08/2026.
//

import Observation
import SwiftUI

enum AppTab: Hashable {
    case main
    case places
    case expenses
    case stats
}

struct PlaceFocusRequest: Equatable {
    let ticket = UUID()
    let place: Place
}

struct RecordOpenRequest: Equatable {
    let ticket = UUID()
    let record: ExpenseRecord
}

@Observable
final class AppRouter {
    var selectedTab: AppTab = .main
    
    // реквест на мето, на котором нужно сфокусировать карту
    var placeFocusRequest: PlaceFocusRequest?
    
    // реквест для отрытия записи на вкладке расходов
    var recordOpenRequest: RecordOpenRequest?
}
