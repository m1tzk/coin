//
//  PlacesCard.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct PlacesCard: View {
    @State private var animationTrigger: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ImageBView()
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 250, height: 120)
                .foregroundStyle(.tint)
                .blur(radius: 25)
                .overlay {
                    VStack(alignment: .leading) {
                        Text("Placeholder")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                            .foregroundStyle(.white)
                        
                        Text("Test text")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontWidth(.condensed)
                            .foregroundStyle(.white)
                    }
                }
        }
        .overlay (alignment: .topTrailing) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 46))
                .symbolEffect(.bounce.down.byLayer, value: animationTrigger)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color("AccentColor"))
                .frame(width: 58, height: 58, alignment: .center)
                .padding([.top, .trailing])
        }
        .aspectRatio(1.75 / 3.0, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 16))
        .contentShape(Rectangle())
        .onTapGesture {
            animationTrigger.toggle()
        }
    }
}

#Preview {
    PlacesCard()
}
