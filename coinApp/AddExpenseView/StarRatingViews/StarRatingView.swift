//
//  StarRatingView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 17/08/2026.
//
import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(1...5, id: \.self) { value in
                let isSelected = value <= rating

                Button {
                    withAnimation(.snappy(duration: 0.25)) {
                        rating = rating == value ? 0 : value
                    }
                } label: {
                    Image(
                        systemName: isSelected
                            ? "star.fill"
                            : "star"
                    )
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        isSelected
                            ? Color("AccentColor")
                            : Color.secondary
                    )
                    .contentTransition(.symbolEffect(.replace))
                    .symbolEffect(
                        .bounce,
                        options: .nonRepeating,
                        value: isSelected
                    )
                    .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Оценка \(value) из 5")
            }
        }
    }
}
