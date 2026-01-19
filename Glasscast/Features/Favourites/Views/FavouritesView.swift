//
//  FavouritesView.swift
//  Glasscast
//
//  Display list of favorite cities with weather
//

import SwiftUI

struct FavouritesView: View {
    @State private var viewModel = FavouritesViewModel()
    private var preferences = PreferencesService.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Cities")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        Text("\(viewModel.favorites.count) saved")
                            .font(.system(size: 14))
                            .foregroundColor(.primary.opacity(0.5))
                    }
                    Spacer()
                }
                .padding(.top, 60)
                
                // Content
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.favorites.isEmpty {
                    emptyView
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.favorites) { cityWithWeather in
                            FavoriteCityCard(
                                cityWithWeather: cityWithWeather,
                                onDelete: {
                                    Task {
                                        await viewModel.removeFavorite(cityWithWeather)
                                    }
                                }
                            )
                        }
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 24)
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadFavorites()
        }
        .onChange(of: preferences.temperatureUnit) { _, _ in
             Task {
                 await viewModel.refresh()
             }
         }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.primary)
            Text("Loading favorites...")
                .foregroundColor(.primary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.primary.opacity(0.3))
            
            Text("No Favorites Yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("Search for cities on the Home tab\nand tap + to add them here")
                .font(.system(size: 14))
                .foregroundColor(.primary.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

// MARK: - Favorite City Card
struct FavoriteCityCard: View {
    let cityWithWeather: FavoriteCityWithWeather
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Weather Icon
            ZStack {
                Circle()
                    .fill(Color.primary.opacity(0.1))
                    .frame(width: 56, height: 56)
                
                if let weather = cityWithWeather.weather {
                    Image(systemName: weather.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                } else if cityWithWeather.isLoading {
                    ProgressView()
                        .tint(.primary)
                }
            }
            
            // City Info
            VStack(alignment: .leading, spacing: 4) {
                Text(cityWithWeather.favorite.cityName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(cityWithWeather.favorite.country)
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.5))
                
                if let weather = cityWithWeather.weather {
                    Text(weather.conditionDescription)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "4763eb"))
                }
            }
            
            Spacer()
            
            // Temperature
            if let weather = cityWithWeather.weather {
                Text(weather.temperatureString)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(.primary)
            }
            
            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.red.opacity(0.7))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
        )
    }
}


#Preview {
    ZStack {
        PremiumBackground()
        FavouritesView()
    }
}
