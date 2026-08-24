////
////  PreviewData.swift
////  coinApp
////
////  Created by Ермолицкий Иван on 10/08/2026.
////
//
//import Foundation
//import SwiftData
//
//enum PreviewData {
//    @MainActor
//    static func makeContainer() -> ModelContainer {
//        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
//        
//        let container = try! ModelContainer(for: ExpenseRecord.self, ExpenseItem.self, configurations: configuration)
//        
//        let market = ExpenseRecord(placeName: "ProStore", latitude: 53.847630, longitude: 27.471086, currencyCode: "BYN",)
//        market.items = [
//            ExpenseItem(
//                serviceName: "Вода питьевая",
//                quantity: 10,
//                unitPrice: -14.60),
//            ExpenseItem(
//                serviceName: "Пицца 36",
//                quantity: 1,
//                unitPrice: -21.90),
//            ExpenseItem(
//                serviceName: "Грудка куриная",
//                quantity: 2,
//                unitPrice: -4.37),
//            ExpenseItem(
//                serviceName: "Вода питьевая",
//                quantity: 10,
//                unitPrice: -14.60),
//            ExpenseItem(
//                serviceName: "Пицца 36",
//                quantity: 1,
//                unitPrice: -21.90),
//            ExpenseItem(
//                serviceName: "Грудка куриная",
//                quantity: 2,
//                unitPrice: -4.37),
//            ExpenseItem(
//                serviceName: "Вода питьевая",
//                quantity: 10,
//                unitPrice: -14.60),
//            ExpenseItem(
//                serviceName: "Пицца 36",
//                quantity: 1,
//                unitPrice: -21.90),
//            ExpenseItem(
//                serviceName: "Грудка куриная",
//                quantity: 2,
//                unitPrice: -4.37),
//            ExpenseItem(
//                serviceName: "Вода питьевая",
//                quantity: 10,
//                unitPrice: -14.60),
//            ExpenseItem(
//                serviceName: "Пицца 36",
//                quantity: 1,
//                unitPrice: -21.90),
//            ExpenseItem(
//                serviceName: "Грудка куриная",
//                quantity: 2,
//                unitPrice: -4.37)
//        ]
//        
//        let cinema = ExpenseRecord(placeName: "Skyline Cinema", latitude: 53.890198, longitude: 27.554219, currencyCode: "BYN")
//        cinema.items = [
//            ExpenseItem(
//                serviceName: "Билеты",
//                quantity: 4,
//                unitPrice: -64),
//            ExpenseItem(
//                serviceName: "Попкорн",
//                quantity: 2,
//                unitPrice: -21)
//        ]
//        
//        container.mainContext.insert(market)
//        container.mainContext.insert(cinema)
//        
//        return container
//    }
//}
