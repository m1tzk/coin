//
//  PlacesOnMapView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 12/08/2026.
//

import SwiftUI
import SwiftData
import MapKit

struct PlacesOnMapView: View {
    
    @Query(
        sort: \Place.name,
        order: .forward
    )
    
    private var places: [Place]

    @Namespace private var mapScope
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    @State private var mapStyle: MapDisplayStyle = .standard
    
    @State private var locationManager = LocationManager()
    
    @State private var selectedPlaceId: PersistentIdentifier?
    @State private var selectedPlace: LocatedPlace?
    
    @State private var searchText = ""
    
    var focusPlace: Place? = nil
    
    private struct LocatedPlace: Identifiable {
        let place: Place
        let coordinate: CLLocationCoordinate2D
        
        var id: PersistentIdentifier {
            place.persistentModelID
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $cameraPosition, bounds: MapCameraBounds(minimumDistance: 50), interactionModes: .all, selection: $selectedPlaceId, scope: mapScope) {
                UserAnnotation()
                
                ForEach(locatedPlaces) { place in
                    Marker(place.place.name, coordinate: place.coordinate)
                        .tag(place.id)
                }
            }
            .mapStyle(mapStyle.style)
            .mapScope(mapScope)
        }
        .navigationTitle("Места")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    PlaceListView()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundStyle(Color("AccentColor"))
                }
                .accessibilityLabel("Список мест")
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Button("По умолчанию") {
                        mapStyle = .standard
                    }
                    Button("Спутник") {
                        mapStyle = .imagery
                    }
                } label: {
                    Image(systemName: "map")
                        .font(.title2)
                        .foregroundStyle(Color("AccentColor"))
                }
                .accessibilityLabel("Тип отображения карты")
                
                Button {
                    locationManager.requestCurrentLocation()
                } label: {
                    Image(systemName: "location.fill")
                        .font(.title2)
                        .foregroundStyle(Color("AccentColor"))
                }
                .accessibilityLabel("Показать текущее местоположение")
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Поиск мест")
        .searchSuggestions {
            ForEach(filteredPlaces) { place in
                Button {
                    getFocus(on: place)
                    searchText = ""
                } label: {
                    Label(place.place.name, systemImage: "mappin.and.ellipse")
                }
            }
        }
        .task {
            locationManager.requestCurrentLocation()
            
            if let focusPlace, let coordinate = focusPlace.coordinate {
                cameraPosition = .camera(
                    MapCamera(centerCoordinate: coordinate, distance: 850, heading: 0, pitch: 0)
                )
                selectedPlaceId = focusPlace.persistentModelID
            }
        }
        .onChange(of: locationManager.locationRevision) {
            getFocusOnUserLocation()
        }
        .onChange(of: selectedPlaceId) { _, id in
            guard let id, let place = locatedPlaces.first(where: { $0.id == id})
            else {return}
            
            getFocus(on: place)
            
            Task {
                try? await Task.sleep(for: .milliseconds(260))
                guard selectedPlaceId == id else { return }
                
                selectedPlace = place
            }
        }
        .sheet(item: $selectedPlace, onDismiss: { selectedPlaceId = nil }) { place in
            PlaceDetailSheet(place: place.place)
        }
    }
}

private extension PlacesOnMapView {
    enum MapDisplayStyle {
        case standard
        case imagery
        
        var style: MapStyle {
            switch self {
            case .standard:
                return .standard
            case .imagery:
                return .imagery
            }
        }
    }
    
    private var filteredPlaces: [LocatedPlace] {
        guard !searchText.isEmpty else {
            return []
        }
        
        return locatedPlaces.filter {
            $0.place.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var locatedPlaces: [LocatedPlace] {
        places.compactMap { place in
            guard let coordinate = place.coordinate
            else {
                return nil
            }
            
            return LocatedPlace(place: place, coordinate: coordinate)
        }
    }
    
    func getFocusOnUserLocation() {
        guard let coordinate = locationManager.currentCoordinate else { return }
        withAnimation(.smooth) {
            cameraPosition = .camera(MapCamera(centerCoordinate: coordinate, distance: 850, heading: 0, pitch: 0))
        }
    }
    
    private func getFocus(on place: LocatedPlace) {
        withAnimation(.smooth) {
            cameraPosition = .camera(MapCamera(centerCoordinate: place.coordinate, distance: 850, heading: 0, pitch: 0))
        }
    }
}

//#Preview {
//    PlacesOnMapView()
//        .modelContainer(PreviewData.makeContainer())
//}
