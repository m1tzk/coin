//
//  TextBView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct TextBView: View {
    let place: Place
    
    var body: some View {
        //        ZStack (alignment: .leading) {
        //            RoundedRectangle(cornerRadius: 25)
        //                .frame(width: 250, height: 120)
        //                .foregroundStyle(.tint)
        //                .blur(radius: 25)
        //                .overlay {
        //                    VStack(alignment: .leading) {
        //                        Text("Недавно добавлено")
        //                            .font(.caption.weight(.semibold))
        //                            .foregroundStyle(.white.opacity(0.85))
        //                            .textCase(.uppercase)
        //                        
        //                        Text(place.name)
        //                            .font(.title2.weight(.semibold))
        //                            .foregroundStyle(.white)
        //                            .lineLimit(2)
        //                        
        //                        if place.coordinate != nil {
        //                            ReverseGeocodedAddressView(coordinate: place.coordinate)
        //                                .font(.subheadline)
        //                                .foregroundStyle(.white.opacity(0.85))
        //                        }
        //                    }
        //                    .shadow(color: .black.opacity(0.4), radius: 4, y: 1)
        //                }
        //        }
        //    }
        VStack(alignment: .leading, spacing: 6) {
            Text("НОВОЕ МЕСТО")
                .font(.caption2.weight(.bold))
                .fontWidth(.expanded)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial, in: Capsule())
                .environment(\.colorScheme, .dark)
            
            Text(place.name)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1)
            
            if place.coordinate != nil {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption2)
                    ReverseGeocodedAddressView(coordinate: place.coordinate)
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(1)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    TextBView()
//}
