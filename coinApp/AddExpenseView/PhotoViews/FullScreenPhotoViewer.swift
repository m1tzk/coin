//
//  FullScreenPhotoViewer.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 20/08/2026.
//

import SwiftUI
import SwiftData

struct FullScreenPhotoViewer: View {
    let photos: [ExpensePhoto]
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPhotoId: PersistentIdentifier
    
    init(photos: [ExpensePhoto], initialPhoto: ExpensePhoto) {
        self.photos = photos
        _selectedPhotoId = State(initialValue: initialPhoto.persistentModelID)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()
            
            TabView(selection: $selectedPhotoId) {
                ForEach(photos, id: \.persistentModelID) { photo in
                    if let image = UIImage(data: photo.imageData) {
                        ZoomablePhotoViewer(image: image)
                            .tag(photo.persistentModelID)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.black.opacity(0.35), in: .circle)
            }
            .padding(.top, 12)
            .padding(.trailing, 16)
            .accessibilityLabel("Закрыть прсомотр фотографий")
        }
    }
}

struct ZoomablePhotoViewer: View {
    let image: UIImage
    
    @State private var scale: CGFloat = 1
    @State private var baseScale: CGFloat = 1
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        // где value.magnification - относительный коэф жеста
                        scale = min(max(baseScale * value.magnification, 1), 4)
                        // scale ограничивает масштаб - min 1х, max 2х
                    }
                    .onEnded { _ in
                        baseScale = scale
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.snappy) {
                    if scale > 1 {
                        scale = 1
                        baseScale = 1
                    } else {
                        scale = 2.5
                        baseScale = 2.5
                    }
                    
                }
            }
    }
}

//#Preview {
//    FullScreenPhotoViewer()
//}
