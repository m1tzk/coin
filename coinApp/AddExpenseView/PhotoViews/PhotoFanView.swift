//
//  PhotoFanView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 17/08/2026.
//

import SwiftUI

struct PhotoFanView: View {
    let photos: [ExpensePhotoDraft]
    let onDelete: (ExpensePhotoDraft.ID) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            ForEach(
                Array(photos.enumerated()),
                id: \.element.id
            ) { index, photo in
                if let image = UIImage(data: photo.data) {
                        PhotoThumbnail(image: image, index: index + 1, onDelete: {
                            onDelete(photo.id)
                            }
                    )
                    .rotationEffect(
                        .degrees(fanAngle(for: index))
                    )
                    .offset(
                        x: horizontalOffset(for: index),
                        y: abs(fanAngle(for: index)) * 0.35
                    )
                    .zIndex(Double(index))
                    .transition(.opacity.combined(with: .scale(scale: 0.88)))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .animation(.smooth(duration: 0.28), value: photos.map(\.id))
    }
    
    private func horizontalOffset(for index: Int) -> CGFloat {
        let middle = CGFloat(photos.count - 1) / 2
        return (CGFloat(index) - middle) * 24
    }

    private func fanAngle(for index: Int) -> Double {
        let middle = Double(photos.count - 1) / 2
        return (Double(index) - middle) * 5
    }
}

struct PhotoThumbnail: View {
    let image: UIImage
    let index: Int
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 86, height: 112)
                .clipShape(.rect(cornerRadius: 12))
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color("AccentColor"))
            }
            .buttonStyle(.plain)
            .padding(5)
            .accessibilityLabel("Удалить фотографию \(index)")
        }
    }
}

//ZStack(alignment: .topTrailing) {
//    Image(uiImage: image)
//        .resizable()
//        .scaledToFill()
//        .frame(width: 86, height: 112)
//        .clipShape(.rect(cornerRadius: 12))
//
//    Button {
//        withAnimation(.snappy) {
//            onDelete(index)
//        }
//    } label: {
//        Image(systemName: "xmark.circle.fill")
//            .symbolRenderingMode(.hierarchical)
//            .foregroundStyle(.white, .black.opacity(0.45))
//    }
//    .buttonStyle(.plain)
//    .padding(4)
//    .accessibilityLabel("Удалить фотографию \(index + 1)")
//}
