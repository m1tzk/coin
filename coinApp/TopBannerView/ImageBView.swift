//
//  ImageBView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct ImageBView: View {
    var body: some View {
        Rectangle()
            .fill(.background)
            .overlay {
                Image("lastVisitedProto")
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
    }
}

#Preview {
    ImageBView()
}
