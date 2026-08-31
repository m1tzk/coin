//
//  PlaceDetailSheet.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 20/08/2026.
//

import SwiftUI
import SwiftData
import CoreLocation

struct PlaceDetailSheet: View {
    let place: Place
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var detent: PresentationDetent
    
    private let compactDetent: PresentationDetent = .fraction(0.22)
    
    private var isLarge: Bool { detent == .large }

    init(place: Place) {
        self.place = place
        _detent = State(initialValue: PresentationDetent.fraction(0.22))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isLarge {
                    largeLayout
                        .ignoresSafeArea(edges: .top)
                } else {
                    compactLayout
                }
            }
            .toolbar(isLarge ? .hidden : .visible, for: .navigationBar)
            .animation(.easeInOut(duration: 0.25), value: isLarge)
        }
        .presentationDetents([compactDetent, .large], selection: $detent)
        .presentationDragIndicator(.visible)
    }
    
    private var compactLayout: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(place.name)
                .font(.title3.weight(.semibold))
                .lineLimit(2)
            
            ReverseGeocodedAddressView(coordinate: place.coordinate)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Средняя оценка: ")
                    .font(.subheadline.weight(.semibold))
                
                if let rating = place.averageRating {
                    HStack(spacing: 6) {
                        ReadOnlyStarRatingView(rating: Int(rating.rounded()))
//                        Text(rating.formatted(.number.precision(.fractionLength(1))))
//                            .font(.subheadline.weight(.semibold))
//                            .monospacedDigit()
                    }
                } else {
                    Text("Оценка не проставлена.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Потрачено за все время: ")
                    .font(.subheadline.weight(.semibold))
                
                Text(place.totalSpent, format: .currency(code: "BYN"))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color("AccentColor"))
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .bottom], 20)
        .padding(.top, 5)
    }
    
    private var largeLayout: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if !orderedPhotos.isEmpty {
                    PlacePhotoGallery(photos: orderedPhotos)
                        .frame(height: 320)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(place.name)
                        .font(.title2.weight(.semibold))
                    
                    ReverseGeocodedAddressView(coordinate: place.coordinate)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Средняя оценка: ")
                            .font(.subheadline.weight(.semibold))
                        
                        if let rating = place.averageRating {
                            HStack(spacing: 6) {
                                ReadOnlyStarRatingView(rating: Int(rating.rounded()))
//                                Text(rating.formatted(.number.precision(.fractionLength(1))))
//                                    .font(.subheadline.weight(.semibold))
//                                    .monospacedDigit()
                            }
                        } else {
                            Text("Оценка не проставлена.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Text("Потрачено за все время: ")
                        .font(.subheadline.weight(.semibold))
                    Text(place.totalSpent, format: .currency(code: "BYN"))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color("AccentColor"))
                        .monospacedDigit()
                }
                .padding(.horizontal, 20)
                
                servicesSection
                    .padding(.horizontal, 20)
            }
            .padding(.top, orderedPhotos.isEmpty ? 18 : 0)
            .padding(.bottom, 32)
        }
    }
    
    private var orderedPhotos: [ExpensePhoto] {
        place.visits
            .sorted {
                $0.createdAt > $1.createdAt
                // первый визит раньше второго если его дата позже
        }
            .flatMap { visit in
                visit.photos
                    .sorted {
                        $0.sortOrder < $1.sortOrder
                        // сиходный порядок фотографий, прикрепленных пользователем
                }
            }
    }
    
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // relationship массив может возвращаться в не заданном порядке, поэтому явно задаем порядок на более новые - более старые посещения
            ForEach(place.visits.sorted {
                    $0.createdAt > $1.createdAt },
                    id: \.persistentModelID
            ) { visit in
                VStack(alignment: .leading, spacing: 8) {
                    Text(visit.createdAt.formatted(date: .long, time: .shortened))
                        .font(.headline)
                    
                    ExpenseItemTableView(items: visit.items, currencyCode: visit.currencyCode)
                }
            }
        }
    }
    
}

//#Preview {
//    PlaceDetailView()
//}
