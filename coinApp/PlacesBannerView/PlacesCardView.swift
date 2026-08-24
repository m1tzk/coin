//
//  PlacesCardView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct PlacesCardView: View {
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading, spacing: 6) {
                Text("Места")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                    .foregroundStyle(Color(.text))
                
                Text("Где и как вы проводили свое время")
                    .font(.headline)
                    .fontWeight(.medium)
                    .fontWidth(.expanded)
                    .foregroundStyle(Color(.text))
            }
            .padding(.horizontal, 22)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -16) {
                    ForEach (0...5, id: \.self) { _ in
                        PlacesCard()
                            .containerRelativeFrame(.horizontal) { size, axis in
                                size * 0.85
                            }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    PlacesCardView()
}
