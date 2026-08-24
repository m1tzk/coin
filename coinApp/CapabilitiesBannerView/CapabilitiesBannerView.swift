//
//  CapabilitiesBannerView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct CapabilitiesBannerView: View {

    
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading, spacing: 6) {
                Text("Финансы")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                    .foregroundStyle(Color(.text))
                
                Text("Управляйте своими расходами")
                    .font(.headline)
                    .fontWeight(.medium)
                    .fontWidth(.expanded)
                    .foregroundStyle(Color(.text))
            }
            .padding(.horizontal, 22)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -16) {
                    ForEach (Capabilities.allCases) { capability in
                        NavigationLink(value: capability) {
                            CapabilitiesCard(capabilities: capability)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.85
                                }
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
    CapabilitiesBannerView()
}
