//
//  ReadOnlyStarRatingView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 20/08/2026.
//

import SwiftUI

struct ReadOnlyStarRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { value in
                Image(systemName: value <= rating ? "star.fill" : "star")
                    .foregroundStyle(value <= rating ? Color("AccentColor") : .secondary)
            }
            
            Text("\(rating) из 5")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
        }
    }
}

//#Preview {
//    ReadOnlyStarRatingView()
//}
