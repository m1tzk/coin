//
//  ImageBView.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//
import SwiftUI

struct ImageBView: View {
    let imageData: Data?
    
    var body: some View {
        GeometryReader { geometry in
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                ZStack {
                    Color("AccentColor").opacity(0.2)
                    Image(systemName: "photo")
                        .font(.system(size: 36))
                        .foregroundStyle(.secondary)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

//#Preview {
//    ImageBView()
//}
