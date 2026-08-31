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
                VStack(alignment: .leading, spacing: 32) {
                    TopBannerView()
                        .containerRelativeFrame(.vertical) { size, _ in
                            size * 0.62
                        }
                    
                    CapabilitiesBannerView()
                    
                    PlacesCardView()
                }
                .padding(.bottom, 32)
            }
            .ignoresSafeArea(edges: .top)
            .navigationTitle("Главная")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
}


struct CardScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

//#Preview {
//    MainPageView()
//}
