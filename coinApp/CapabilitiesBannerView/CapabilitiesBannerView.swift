//
//  CapabilitiesBannerView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct CapabilitiesBannerView: View {
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack (alignment: .leading, spacing: 14) {
            VStack (alignment: .leading, spacing: 4) {
                Text("Финансы")
                    .font(.title.weight(.bold))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                
                Text("Управляйте своими расходами")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach (Capabilities.allCases) { capability in
                        Button {
                            router.selectedTab = targetTab(for: capability)
                        } label: {
                            CapabilitiesCard(capabilities: capability)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.82
                                }
                        }
                        .buttonStyle(CardScaleButtonStyle())
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 20, for: .scrollContent)
        }
    }
    
    private func targetTab(for capability: Capabilities) -> AppTab {
        switch capability {
        case .briefFinanceRecord:
                return .expenses
        case .financeGraphRepresentation, .overallStatistics:
            return .stats
        }
    }
}

#Preview {
    CapabilitiesBannerView()
}
