//
//  FavouritesViewModel.swift
//  Glasscast
//
//  ViewModel for Favourites Screen
//

import SwiftUI

/// City with weather data for display
struct FavoriteCityWithWeather: Identifiable {
    let favorite: FavoriteCity
    var weather: WeatherData?
    var isLoading: Bool = true
    
    var id: UUID { favorite.id }
}

@Observable
@MainActor
class FavouritesViewModel {
    var favorites: [FavoriteCityWithWeather] = []
    var isLoading: Bool = true
    var errorMessage: String?
    
    private let favoritesService = FavoritesService.shared
    private let weatherService = WeatherService.shared
    
    // MARK: - Load Favorites
    func loadFavorites() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let favs = try await favoritesService.fetchFavorites()
            favorites = favs.map { FavoriteCityWithWeather(favorite: $0) }
            isLoading = false
            
            // Load weather for each favorite
            await loadWeatherForFavorites()
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Load Weather for All Favorites
    private func loadWeatherForFavorites() async {
        for index in favorites.indices {
            let fav = favorites[index]
            do {
                let weather = try await weatherService.fetchWeather(
                    lat: fav.favorite.lat,
                    lon: fav.favorite.lon
                )
                favorites[index].weather = weather
                favorites[index].isLoading = false
            } catch {
                favorites[index].isLoading = false
            }
        }
    }
    
    // MARK: - Remove Favorite
    func removeFavorite(_ favorite: FavoriteCityWithWeather) async {
        do {
            try await favoritesService.removeFavorite(id: favorite.id)
            favorites.removeAll { $0.id == favorite.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Refresh
    func refresh() async {
        await loadFavorites()
    }
}
