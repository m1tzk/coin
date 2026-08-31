//
//  TopBannerView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI
import SwiftData	

struct TopBannerView: View {
    //    var body: some View {
    //        TabView {
    //            ZStack(alignment: .bottomLeading) {
    //                ImageBView()
    //                TextBView()
    //                    .modifier(TextPadModifier())
    //            }
    //
    //
    //            ZStack(alignment: .bottomLeading) {
    //                ImageBView()
    //                TextBView()
    //                    .modifier(TextPadModifier())
    //
    //            }
    //
    //            ZStack(alignment: .bottomLeading) {
    //                ImageBView()
    //                TextBView()
    //                    .modifier(TextPadModifier())
    //
    //            }
    //
    //        }
    //        // нужен .containerRelativeFrame в родительском контейнере
    //        .tabViewStyle(.page)
    //    }
    @Query(sort: \Place.name)
    private var places: [Place]
    
    // Места за последние 5 дней, максимум 5
    private var recentPlaces: [Place] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        let recent = places
            .filter { ($0.createdAt ?? .distantPast) >= weekAgo }
            .sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
        return Array(recent.prefix(5))
    }
    
    var body: some View {
        Group {
            if recentPlaces.isEmpty {
                ZStack {
                    Color(uiColor: .secondarySystemBackground)
                    VStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        Text("Нет новых мест за последнюю неделю")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                TabView {
                    ForEach(recentPlaces) { place in
                        BannerSlide(place: place)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: recentPlaces.count > 1 ? .automatic : .never))
            }
        }
    }
}

private struct BannerSlide: View {
    let place: Place
    
    private var photos: [ExpensePhoto] {
        place.visits
            .sorted { $0.createdAt > $1.createdAt }
            .flatMap{ $0.photos.sorted { $0.sortOrder < $1.sortOrder } }
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ImageBView(imageData: photos.pseudoRandomElement(seed: place.persistentModelID)?.imageData)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            LinearGradient(
                colors: [.clear,
                         .black.opacity(0.15),
                         .black.opacity(0.65)],
                startPoint: .center, endPoint: .bottom)
            
            TextBView(place: place)
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
        }
    }
}

struct TextPadModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading)
            .padding(.bottom, 26)
    }
}

#Preview {
    TopBannerView()
}
