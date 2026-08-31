//
//  CapabilitiesCard.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct CapabilitiesCard: View {
    let capabilities: Capabilities
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Image(systemName: capabilities.icon)
                    .font(.system(size: 42))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color("AccentColor"))
                    .frame(width: 52, height: 52)
                    .padding([.top, .trailing], 16)
            }
            Spacer(minLength: 12)
            VStack(alignment: .leading, spacing: 4) {
                Text(capabilities.name)
                    .font(.title2.weight(.bold))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                
                Text(capabilities.description)
                    .font(.subheadline.weight(.medium))
                    .fontWidth(.condensed)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding([.leading, .trailing, .bottom], 16)
            
        }
        .aspectRatio(16.0 / 10.0, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
                .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 3)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    CapabilitiesCard(capabilities: Capabilities.allCases.randomElement()!)
}
