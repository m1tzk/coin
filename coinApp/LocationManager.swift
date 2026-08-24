//
//  LocationManager.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 12/08/2026.
//

import CoreLocation
import Observation

@Observable
@MainActor
final class LocationManager: NSObject, CLLocationManagerDelegate {
    // принудительно говорим UI не следить за именениями CLLocationManager (потому что его изменения технически не меняют UI)
    @ObservationIgnored
    private let manager: CLLocationManager
    
    private(set) var currentCoordinate: CLLocationCoordinate2D?
    private(set) var locationRevision = 0
    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var errorMessage: String?
    
    override init() {
        let manager = CLLocationManager()
        self.manager = manager
        self.authorizationStatus = manager.authorizationStatus
        
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestCurrentLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            
        case .denied, .restricted:
            errorMessage = "Доступ к геопозиции отключен. Для предоставления доступа, перейдите в настройки приложения."
        
            // unknown отсылает уведомление о необходимости изменить код при добавлении новой функциональности в enum CLAuthorizationStatus
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoordinate = locations.last?.coordinate
        locationRevision += 1
        errorMessage = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = "Не удалость определить геопозицию."
    }
}
