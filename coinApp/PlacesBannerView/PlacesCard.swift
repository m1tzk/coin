//
//  PlacesCard.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI
import SwiftData

struct PlacesCard: View {
    let record: ExpenseRecord
    
    @Environment(\.colorScheme) private var colorScheme
    
//    // самое последнее посещение
//    private var lastVisit: ExpenseRecord? {
//        place.visits.max { $0.createdAt < $1.createdAt }
//    }
    
    // якобы случ фото из последнего посещения
    private var photoData: Data? {
        let photos = record.photos.sorted { $0.sortOrder < $1.sortOrder }
        return photos.pseudoRandomElement(seed: record.persistentModelID)?.imageData
    }
    
    private var place: Place? {
        record.place
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ImageBView(imageData: photoData)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            LinearGradient(
                colors: [.clear,
                         .black.opacity(0.2),
                         .black.opacity(0.85)],
                startPoint: .center, endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(place?.name ?? "Наименование не указано")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .shadow(color: .black.opacity(0.5), radius: 3, y: 1)
                
                if let coordinate = place?.coordinate {
                    ReverseGeocodedAddressView(coordinate: coordinate)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(1)
                        .shadow(color: .black.opacity(0.4), radius: 2, y: 1)
                }
                
                Text(record.totalSpent
                    .formatted(
                        .currency(code: record.currencyCode)
                        .precision(.fractionLength(2)))
                )
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(colorScheme == .dark ? .white : Color("AccentColor"))
                .monospacedDigit()
                .padding(.top, 2)
                .shadow(color: .black.opacity(0.4), radius: 2, y: 1)
                
            }
            .padding(16)
        }
        .overlay (alignment: .topTrailing) {
            Image(systemName: place?.coordinate != nil ? "mappin.and.ellipse" : "list.bullet.rectangle")
                .font(.system(size: 15, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(colorScheme == .dark ? .white : Color("AccentColor"))
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
                .padding(12)
        }
        .aspectRatio(16.0 / 10.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
        
            
            
//            RoundedRectangle(cornerRadius: 25)
//                .frame(width: 250, height: 120)
//                .foregroundStyle(.tint)
//                .blur(radius: 25)
//                .overlay {
//                    VStack(alignment: .leading) {
//                        Text("Placeholder")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .fontWidth(.expanded)
//                            .foregroundStyle(.white)
//                        
//                        Text("Test text")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .fontWidth(.condensed)
//                            .foregroundStyle(.white)
//                    }
//                }
//        }
//        .overlay (alignment: .topTrailing) {
//            Image(systemName: "mappin.and.ellipse")
//                .font(.system(size: 46))
//                .symbolEffect(.bounce.down.byLayer, value: animationTrigger)
//                .symbolRenderingMode(.hierarchical)
//                .foregroundStyle(Color("AccentColor"))
//                .frame(width: 58, height: 58, alignment: .center)
//                .padding([.top, .trailing])
//        }
//        .aspectRatio(1.75 / 3.0, contentMode: .fit)
//        .clipShape(.rect(cornerRadius: 16))
//        .contentShape(Rectangle())
//        .onTapGesture {
//            animationTrigger.toggle()
//        }
//    }
//}
//
//#Preview {
//    PlacesCard()
//}
