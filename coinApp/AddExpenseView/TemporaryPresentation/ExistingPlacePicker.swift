//
//  ExistingPlacePicker.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 24/08/2026.
//

import SwiftUI
import SwiftData

struct ExistingPlacePicker: View {
    let onSelect: (Place) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Place.name, order: .forward)
    private var places: [Place]
    
    @State private var searchText = ""
    
    var body: some View {
        List(filteredPlaces) { place in
            Button {
                onSelect(place)
                dismiss()
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .foregroundStyle(.primary)
                    
                    if let lastVisitedAt = place.lastVisitedAt {
                        Text("Последнее посещение: " + lastVisitedAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Выберите место")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $searchText,
            prompt: "Поиск места"
        )
//        .toolbar {
//            ToolbarItem(placement: .cancellationAction) {
//                Button("Отмена") {
//                    dismiss()
//                }
//            }
//        }
    }
    
    private var filteredPlaces: [Place] {
        guard !searchText.isEmpty else { return places }
        
        return places.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

//#Preview {
//    ExistingPlacePicker()
//}
