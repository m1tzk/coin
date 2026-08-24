//
//  PlacePhotoGallery.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 20/08/2026.
//

import SwiftUI

struct PlacePhotoGallery: View {
    let photos: [ExpensePhoto]
    
    @State private var selectedPhoto: ExpensePhoto?
    
    var body: some View {
        TabView {
            ForEach(photos) { photo in
                if let image = UIImage(data: photo.imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPhoto = photo
                        }
                }
            }
        }
        .tabViewStyle(.page)
        .fullScreenCover(item: $selectedPhoto) { photo in
            FullScreenPhotoViewer(photos: photos, initialPhoto: photo)
        }
    }
}

//#Preview {
//    PlacePhotoGallery()
//}
