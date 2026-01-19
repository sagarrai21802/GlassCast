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
    var forecast: [DailyForecast] = []
    
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
            
            async let weatherTask = weatherService.fetchWeather(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )
            
            async let forecastTask = weatherService.fetchForecast(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )
            
            let (weather, forecastItems) = try await (weatherTask, forecastTask)
            
            currentWeather = weather
            processForecast(items: forecastItems)
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
    
    // MARK: - Process Forecast
    private func processForecast(items: [ForecastItem]) {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: items) { item in
            calendar.startOfDay(for: item.date)
        }
        
        let daily = grouped.compactMap { (date, items) -> DailyForecast? in
            guard !items.isEmpty else { return nil }
            
            // Skip today if desired, or keep it. Often "5-day" includes today.
            // Let's include today.
            
            let minTemp = items.map { $0.main.tempMin }.min() ?? 0
            let maxTemp = items.map { $0.main.tempMax }.max() ?? 0
            
            // Find item closest to noon for icon
            let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
            let iconItem = items.min(by: { abs($0.date.timeIntervalSince(noon)) < abs($1.date.timeIntervalSince(noon)) })
            
            return DailyForecast(
                date: date,
                minTemp: minTemp,
                maxTemp: maxTemp,
                icon: iconItem?.iconName ?? "cloud.fill"
            )
        }
        
        // Sort by date and take next 5 days
        forecast = daily.sorted { $0.date < $1.date }.prefix(5).map { $0 }
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

// MARK: - Daily Forecast Model
struct DailyForecast: Identifiable {
    let id = UUID()
    let date: Date
    let minTemp: Double
    let maxTemp: Double
    let icon: String
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

