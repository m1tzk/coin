//
//  PlacesCardView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI
import SwiftData

struct PlacesCardView: View {
    @Query(sort: \ExpenseRecord.createdAt, order: .reverse)
    private var records: [ExpenseRecord]
    
    @Environment(AppRouter.self) private var router
    
    // последние посещенные места, макс 10, у которых есть место
    private var recentVisits: [ExpenseRecord] {
        Array(records
            .filter { $0.place != nil }
            .prefix(10))
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 14) {
            VStack (alignment: .leading, spacing: 4) {
                Text("Посещения")
                    .font(.title2.weight(.bold))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                
                Text("Где вы побывали недавно")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            
            if recentVisits.isEmpty {
                Text("Посещений пока нет")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach (recentVisits) { visit in
                            Button {
                                if let place = visit.place, place.coordinate != nil {
                                    router.placeFocusRequest = .init(place: place)
                                    router.selectedTab = .places
                                } else {
                                    router.recordOpenRequest = .init(record: visit)
                                    router.selectedTab = .expenses
                                }
                            } label: {
                                PlacesCard(record: visit)
                                    .containerRelativeFrame(.horizontal) { size, _ in
                                        size * 0.82
                                    }
                            }
                            .buttonStyle(CardScaleButtonStyle())
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .contentMargins(.horizontal, 20, for: .scrollContent)
            }
        }
    }
}

#Preview {
    PlacesCardView()
}
