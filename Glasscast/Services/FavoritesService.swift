//
//  FavoritesService.swift
//  Glasscast
//
//  Service for managing favorite cities in Supabase
//

import Foundation
import PostgREST
import Auth

/// Favorite City model
struct FavoriteCity: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let cityName: String
    let country: String
    let lat: Double
    let lon: Double
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case cityName = "city_name"
        case country
        case lat, lon
        case createdAt = "created_at"
    }
}

/// For inserting new favorite
struct FavoriteCityInsert: Encodable {
    let userId: UUID
    let cityName: String
    let country: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case cityName = "city_name"
        case country
        case lat, lon
    }
}

/// Favorites Service
@MainActor
class FavoritesService {
    static let shared = FavoritesService()
    
    private init() {}
    
    // MARK: - Fetch Favorites
    func fetchFavorites() async throws -> [FavoriteCity] {
        guard let user = SupabaseService.shared.currentUser else {
            throw FavoritesError.notAuthenticated
        }
        
        let response: [FavoriteCity] = try await SupabaseService.shared.postgrestClient
            .from("favorite_cities")
            .select()
            .eq("user_id", value: user.id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    // MARK: - Add Favorite
    func addFavorite(city: CitySearchResult) async throws {
        guard let user = SupabaseService.shared.currentUser else {
            throw FavoritesError.notAuthenticated
        }
        
        let newFavorite = FavoriteCityInsert(
            userId: user.id,
            cityName: city.name,
            country: city.country,
            lat: city.lat,
            lon: city.lon
        )
        
        try await SupabaseService.shared.postgrestClient
            .from("favorite_cities")
            .insert(newFavorite)
            .execute()
    }
    
    // MARK: - Remove Favorite
    func removeFavorite(id: UUID) async throws {
        try await SupabaseService.shared.postgrestClient
            .from("favorite_cities")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
    
    // MARK: - Check if City is Favorited
    func isFavorite(cityName: String) async throws -> Bool {
        guard let user = SupabaseService.shared.currentUser else {
            return false
        }
        
        let response: [FavoriteCity] = try await SupabaseService.shared.postgrestClient
            .from("favorite_cities")
            .select()
            .eq("user_id", value: user.id.uuidString)
            .eq("city_name", value: cityName)
            .execute()
            .value
        
        return !response.isEmpty
    }
}

// MARK: - Errors
enum FavoritesError: Error, LocalizedError {
    case notAuthenticated
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated: return "Please sign in to save favorites"
        case .saveFailed: return "Failed to save favorite"
        }
    }
}
