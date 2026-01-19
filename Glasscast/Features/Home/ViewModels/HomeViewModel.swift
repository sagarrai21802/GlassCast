//
//  HomeViewModel.swift
//  Glasscast
//
//  ViewModel for Home Screen - handles weather and location
//

import SwiftUI
import CoreLocation

@Observable
@MainActor
class HomeViewModel {
    // MARK: - State
    var searchText: String = ""
    var isSearching: Bool = false
    var isLoading: Bool = true
    var errorMessage: String?
    
    // Weather Data
    var currentWeather: WeatherData?
    var searchResults: [CitySearchResult] = []
    
    // Location
    private let locationService = LocationService.shared
    private let weatherService = WeatherService.shared
    
    // MARK: - Load Current Location Weather
    func loadCurrentLocationWeather() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Request location permission and get coordinates
            let location = try await locationService.getCurrentLocation()
            
            // Fetch weather for current location
            let weather = try await weatherService.fetchWeather(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )
            
            currentWeather = weather
            isLoading = false
        } catch let error as LocationError {
            isLoading = false
            errorMessage = error.localizedDescription
        } catch let error as WeatherError {
            isLoading = false
            errorMessage = error.localizedDescription
        } catch {
            isLoading = false
            errorMessage = "Failed to load weather"
        }
    }
    
    // MARK: - Search Cities
    func searchCities() async {
        guard !searchText.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        do {
            searchResults = try await weatherService.searchCities(query: searchText)
            isSearching = false
        } catch {
            searchResults = []
            isSearching = false
        }
    }
    
    // MARK: - Refresh Weather
    func refreshWeather() async {
        await loadCurrentLocationWeather()
    }
    
    // MARK: - Add to Favorites
    func addToFavorites(_ city: CitySearchResult) async -> Bool {
        do {
            try await FavoritesService.shared.addFavorite(city: city)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}


