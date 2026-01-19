//
//  LocationService.swift
//  Glasscast
//
//  Service for getting user's current location
//

import Foundation
import CoreLocation
import Combine

/// Location Service for getting current coordinates
class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    private let manager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = manager.authorizationStatus
    }
    
    // MARK: - Request Permission
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Get Current Location (Async)
    func getCurrentLocation() async throws -> CLLocation {
        // Check authorization
        switch authorizationStatus {
        case .notDetermined:
            requestPermission()
            // Wait briefly for permission
            try await Task.sleep(nanoseconds: 500_000_000)
        case .denied, .restricted:
            throw LocationError.permissionDenied
        default:
            break
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error.localizedDescription
        locationContinuation?.resume(throwing: LocationError.locationFailed)
        locationContinuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

// MARK: - Errors
enum LocationError: Error, LocalizedError {
    case permissionDenied
    case locationFailed
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Location permission denied. Please enable in Settings."
        case .locationFailed: return "Failed to get your location."
        }
    }
}
