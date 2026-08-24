//
//  TopBannerView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct TopBannerView: View {
    var body: some View {
        TabView {
            ZStack(alignment: .bottomLeading) {
                ImageBView()
                TextBView()
                    .modifier(TextPadModifier())
            }

            
            ZStack(alignment: .bottomLeading) {
                ImageBView()
                TextBView()
                    .modifier(TextPadModifier())
                
            }
            
            ZStack(alignment: .bottomLeading) {
                ImageBView()
                TextBView()
                    .modifier(TextPadModifier())
                
            }
            
        }
        // нужен .containerRelativeFrame в родительском контейнере
        .tabViewStyle(.page)
    }
}

struct TextPadModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading)
            .padding(.bottom, 26)
    }
}

#Preview {
    TopBannerView()
}
