//
//  CoinView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 19/06/2026.
//
import SwiftUI
import SwiftData

struct CoinView: View {
    @State private var router = AppRouter()
    
    var body: some View {
        @Bindable var router = router
        
        TabView(selection: $router.selectedTab) {
            Tab("Главная", systemImage: "fleuron", value: AppTab.main) {
                MainPageView()
            }
            Tab("Места", systemImage: "figure.walk", value: AppTab.places) {
                NavigationStack {
                    PlacesOnMapView()
                }
            }
            Tab("Расходы", systemImage: "banknote", value: AppTab.expenses) {
                BriefFinanceRecordView()
            }
            Tab("Статистика", systemImage: "book.pages", value: AppTab.stats) {
                FinanceStatisticsView()
            }
        }
        .environment(router)
    }
}

//#Preview {
//    CoinView()
////        .modelContainer(PreviewData.makeContainer())
//}
