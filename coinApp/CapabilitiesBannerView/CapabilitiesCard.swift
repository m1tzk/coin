//
//  CapabilitiesCard.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct CapabilitiesCard: View {
    let capabilities: Capabilities
    
    @State private var animationTrigger: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Image(systemName: capabilities.icon)
                    .font(.system(size: 46))
                    .symbolEffect(.bounce.down.byLayer, value: animationTrigger)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color("AccentColor"))
                    .frame(width: 58, height: 58, alignment: .center)
                    .padding([.top, .trailing])
            }
            Spacer()
            VStack(alignment: .leading, spacing: 6) {
                Text(capabilities.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                    .foregroundStyle(Color(.text))
                
                Text(capabilities.description)
                    .font(.headline)
                    .fontWeight(.medium)
                    .fontWidth(.condensed)
                    .foregroundStyle(Color(.text))
                    .lineLimit(2)
            }
            .padding([.leading, .trailing, .bottom])
            
        }
        .aspectRatio(3.0 / 1.75, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.lightGray).opacity(0.2))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            animationTrigger.toggle()
            
            //переход на другой экран
        }
    }
}

#Preview {
    CapabilitiesCard(capabilities: Capabilities.allCases.randomElement()!)
}
