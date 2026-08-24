//
//  PlaceListView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 23/08/2026.
//

import SwiftUI
import SwiftData

struct PlaceListView: View {
    @Query(sort: \Place.name)
    
    private var places: [Place]
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPeriod: FilterPeriod = .all
    
    @State private var searchText = ""
    
    var body: some View {
        List(filteredPlaces) { place in
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.body.weight(.medium))
                
                if let lastVisitedAt = place.lastVisitedAt {
                    Text(lastVisitedAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(place.totalSpent, format: .currency(code: "BYN"))
                    .font(.subheadline)
                    .foregroundStyle(Color("AccentColor"))
                    .monospacedDigit()
            }
        }
        .navigationTitle("Все места")
        .toolbarTitleDisplayMode(.inlineLarge)
//        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Поиск мест...")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Период", selection: $selectedPeriod) {
                        ForEach(FilterPeriod.allCases) { period in
                            Text(period.filterValue)
                                .tag(period)
                        }
                    }
                } label: {
                    Image(systemName: "calendar")
                        .font(.title2)
                        .foregroundStyle(Color("AccentColor"))
                }
                .accessibilityLabel("Выбрать период")
            }
        }
    }
}

private extension PlaceListView {
    var filteredPlaces: [Place] {
        let periodFiltered = places.filter { place in
            place.visits.contains {
                selectedPeriod.contains($0.createdAt)
            }
        }
        guard !searchText.isEmpty else { return periodFiltered }
        return periodFiltered.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

//#Preview {
//    PlaceListView()
//}
