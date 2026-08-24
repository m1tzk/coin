//
//  coinPrototypeAppApp.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//

import SwiftUI
import SwiftData

@main
struct coinApp: App {
    var body: some Scene {
        WindowGroup {
            CoinView()
        }
        .modelContainer(for: [
            ExpenseRecord.self, ExpenseItem.self
        ])
    }
}
