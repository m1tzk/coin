//
//  CoinView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 19/06/2026.
//
import SwiftUI
import SwiftData

struct CoinView: View {
    var body: some View {
        TabView {
            Tab("Главная", systemImage: "fleuron") {
                MainPageView()
            }
            Tab("Места", systemImage: "figure.walk") {
                NavigationStack {
                    PlacesOnMapView()
                }
            }
            Tab("Расходы", systemImage: "banknote") {
                BriefFinanceRecordView()
            }
            Tab("Статистика", systemImage: "book.pages") {}
        }
    }
}

//#Preview {
//    CoinView()
////        .modelContainer(PreviewData.makeContainer())
//}
