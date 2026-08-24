//
//  RatingStar.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 13/08/2026.
//

import SwiftUI

struct RatingStar: View {
    let value: Int
    let isSelected: Bool
    let animationToken: Int
    let action: () -> Void
    
    @State private var scale: CGFloat = 1
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "star.fill" : "star")
                .font(.title2)
                .foregroundStyle(isSelected ? Color("AccentColor") : .secondary)
                .scaleEffect(scale)
                .frame(width: 36, height: 36)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Оценка \(value) из 5")
        .onChange(of: animationToken) {
            animate()
        }
    }
    
    private func animate() {
        withAnimation(.spring(duration: 0.16, bounce: 0.55)) {
            scale = isSelected ? 1.22 : 0.78
        }
        
        withAnimation(.spring(duration: 0.20, bounce: 0.28).delay(0.10)) {
            scale = 1
        }
    }
}

//#Preview {
//    RatingStar()
//}
