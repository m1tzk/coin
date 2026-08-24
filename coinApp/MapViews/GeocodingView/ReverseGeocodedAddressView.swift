//
//  ReverseGeocodedAddressView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 20/08/2026.
//

// перенести в PlaceAddressResolver и добавить кэш по координатам для иммерсивности

import SwiftUI
import MapKit
import CoreLocation

struct ReverseGeocodedAddressView: View {
    let coordinate: CLLocationCoordinate2D?
    
    @State private var address = "Определяем адрес..."
    var body: some View {
        Text(address)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .task(id: geocodingKey) {
                await loadAddress()
            }
    }
    
    private var geocodingKey: String? {
        guard let coordinate else {return nil}
        return "\(coordinate.latitude), \(coordinate.longitude)"
    }
    
    @MainActor
    private func loadAddress() async {
        guard let coordinate else {
            address = "Адрес не указан"
            return
        }
        
        let location = CLLocation(latitude: coordinate.latitude,longitude: coordinate.longitude)
        
        // создание запроса на получение геокода
        guard let request = MKReverseGeocodingRequest(location: location)
        else {
            address = "Адрес не определен."
            return
        }
        
        request.preferredLocale = .current
        
        // асинхронно получаем mapItems
        do {
            let mapItems = try await request.mapItems
            
            // Берем лучший MKMapItem
            guard let mapItem = mapItems.first
            else {
                address = "Адрес не найден."
                return
            }
            
            // И получаем адрес
            address = mapItem.addressRepresentations?.fullAddress(includingRegion: false, singleLine: true) ?? mapItem.address?.shortAddress ?? "Адрес не найден."
        } catch {
            address = "Адрес не найден."
        }
    }
}

//#Preview {
//    ReverseGeocodedAddressView()
//}
