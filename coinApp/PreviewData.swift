//
//  PreviewData.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 21/09/2026.
//

import SwiftUI
import SwiftData

@MainActor
struct PreviewData {
    static let shared = PreviewData()
    let container: ModelContainer

    init() {
        let schema = Schema([
            Place.self,
            ExpenseRecord.self,
            ExpenseItem.self,
            ExpensePhoto.self
        ])
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
            insertMockData(into: container.mainContext)
        } catch {
            fatalError("Не удалось инициализировать Mock ModelContainer: \(error)")
        }
    }
    
    private func insertMockData(into context: ModelContext) {
        // 1. Места
        let cafe = Place(
            name: "Кофейня «Зерно»",
            latitude: 53.9045,
            longitude: 27.5615,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)
        )
        
        let restaurant = Place(
            name: "Ресторан «Васильки»",
            latitude: 53.9022,
            longitude: 27.5534,
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: .now)
        )
        
        let cinema = Place(
            name: "Кинотеатр «Октябрь»",
            latitude: 53.9189,
            longitude: 27.5932,
            createdAt: Calendar.current.date(byAdding: .day, value: -12, to: .now)
        )
        
        let market = Place(
            name: "Супермаркет «Green»",
            latitude: 53.8801,
            longitude: 27.5402,
            createdAt: Calendar.current.date(byAdding: .day, value: -20, to: .now)
        )
        
        context.insert(cafe)
        context.insert(restaurant)
        context.insert(cinema)
        context.insert(market)
        
        // Вспомогательное dummy-изображение 1x1 пиксель
        let dummyPixelData = UIImage(systemName: "photo")?.pngData() ?? Data()
        
        // 2. Расходы / Визиты
        // Визит 1: Сегодня в Кофейню
        let recordToday = ExpenseRecord(currencyCode: "BYN", rating: 5, place: cafe)
        recordToday.createdAt = Date()
        recordToday.items = [
            ExpenseItem(serviceName: "Капучино Grand", quantity: 2, unitPrice: 7.5),
            ExpenseItem(serviceName: "Круассан с миндалем", quantity: 1, unitPrice: 6.0)
        ]
        recordToday.photos = [ExpensePhoto(imageData: dummyPixelData, sortOrder: 0)]
        context.insert(recordToday)
        
        // Визит 2: Вчера в Ресторан
        let recordYesterday = ExpenseRecord(currencyCode: "BYN", rating: 4, place: restaurant)
        recordYesterday.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now
        recordYesterday.items = [
            ExpenseItem(serviceName: "Драники со сметаной", quantity: 2, unitPrice: 16.0),
            ExpenseItem(serviceName: "Квас домашний", quantity: 2, unitPrice: 4.5)
        ]
        context.insert(recordYesterday)
        
        // Визит 3: 3 дня назад повторно в Кофейню (проверка разделения визитов)
        let recordCoffeeOld = ExpenseRecord(currencyCode: "BYN", rating: 5, place: cafe)
        recordCoffeeOld.createdAt = Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now
        recordCoffeeOld.items = [
            ExpenseItem(serviceName: "Фильтр-кофе", quantity: 1, unitPrice: 6.0)
        ]
        context.insert(recordCoffeeOld)
        
        // Визит 4: 10 дней назад в Кино
        let recordCinema = ExpenseRecord(currencyCode: "BYN", rating: 5, place: cinema)
        recordCinema.createdAt = Calendar.current.date(byAdding: .day, value: -10, to: .now) ?? .now
        recordCinema.items = [
            ExpenseItem(serviceName: "Билеты в кино (VIP)", quantity: 2, unitPrice: 22.0),
            ExpenseItem(serviceName: "Попкорн карамельный", quantity: 1, unitPrice: 12.0)
        ]
        context.insert(recordCinema)
        
        // Визит 5: 18 дней назад в Супермаркет
        let recordMarket = ExpenseRecord(currencyCode: "BYN", rating: 3, place: market)
        recordMarket.createdAt = Calendar.current.date(byAdding: .day, value: -18, to: .now) ?? .now
        recordMarket.items = [
            ExpenseItem(serviceName: "Продукты на неделю", quantity: 1, unitPrice: 145.80)
        ]
        context.insert(recordMarket)
        
        try? context.save()
    }
}
