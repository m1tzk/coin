//
//  TextBView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct TextBView: View {
    
    var body: some View {
        ZStack (alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 250, height: 120)
                .foregroundStyle(.tint)
                .blur(radius: 25)
                .overlay {
                    VStack(alignment: .leading) {
                        Text("Ваши места")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                            .foregroundStyle(.white)
                        
                        Text("Получите список любимых мест, в которых вы с удовольствием провели время")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontWidth(.condensed)
                            .foregroundStyle(.white)
                    }
                }
        }
    }
}

#Preview {
    TextBView()
}
