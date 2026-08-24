//
//  MainPageView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 10/08/2026.
//

import SwiftUI

struct MainPageView: View {
    @State private var isAddingExpense = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 42) {
                    TopBannerView()
                        .containerRelativeFrame(.horizontal)
                        .containerRelativeFrame(.vertical) { size, axis in
                            size * 0.7
                        }
                    CapabilitiesBannerView()
                    PlacesCardView()
                }
            }
            .navigationTitle("Главная")
            .navigationDestination(for: Capabilities.self) { capability in
                switch capability {
                case .briefFinanceRecord:
                    BriefFinanceRecordView()
                    
                case .financeGraphRepresentation:
                    Text("граф")
                    
                case .overallStatistics:
                    Text("стат")
                }
                
            }
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                    Button { isAddingExpense = true }
                    label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color("AccentColor"))
                    }
                    .accessibilityLabel("Добавить")
                    .sheet(isPresented: $isAddingExpense) {
                        NavigationStack {
                            AddExpenseView()
                        }
                    }
                }
            }
        }
}

#Preview {
    MainPageView()
}
