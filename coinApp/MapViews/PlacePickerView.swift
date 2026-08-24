//
//  PlacePickerView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 12/08/2026.
//

import SwiftUI
import MapKit
import CoreLocation

struct PlacePickerView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    let placeName: String
    
    @State private var locationManager = LocationManager()
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.9006, longitude: 27.5590), span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    if let selectedCoordinate {
                        Marker(placeName.isEmpty ? "Заведение" : placeName, coordinate: selectedCoordinate)
                    }
                }
                .onTapGesture { point in
                    selectedCoordinate = proxy.convert(point, from: .local)
                }
            }
            .clipShape(.rect(cornerRadius: 16))
            .frame(height: 220)
            
            if let errorMessage = locationManager.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            locationManager.requestCurrentLocation()
        }
        
        .onChange(of: locationManager.locationRevision) {
            guard let coordinate = locationManager.currentCoordinate else {return}
            
            cameraPosition = .region(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        }
    }
}

//#Preview {
//    PlacePickerView()
//}
