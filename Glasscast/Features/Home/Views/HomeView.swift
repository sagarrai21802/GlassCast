//
//  HomeView.swift
//  Glasscast
//
//  Home Screen with Current Weather and City Search
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showSearchResults = false
    private var preferences = PreferencesService.shared
    
    // Animation States
    @State private var showWeatherCard = false
    @State private var showDetailsCard = false
    @State private var showForecast = false
    
    var body: some View {
        ZStack {
            // Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header & Search
                    headerSection
                    
                    // Weather Content
                    if viewModel.isLoading {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(message: error)
                    } else if let weather = viewModel.currentWeather {
                        weatherCard(weather: weather)
                            .offset(y: showWeatherCard ? 0 : 30)
                            .opacity(showWeatherCard ? 1 : 0)
                        
                        detailsCard(weather: weather)
                            .offset(y: showDetailsCard ? 0 : 30)
                            .opacity(showDetailsCard ? 1 : 0)
                        
                        if !viewModel.forecast.isEmpty {
                            forecastSection
                                .offset(y: showForecast ? 0 : 30)
                                .opacity(showForecast ? 1 : 0)
                        }
                    }
                    
                    Spacer(minLength: 100) // Space for tab bar
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
            }
            .refreshable {
                await viewModel.refreshWeather()
                HapticService.mediumImpact()
            }
            
            // Search Results Overlay
            if showSearchResults && !viewModel.searchResults.isEmpty {
                searchResultsOverlay
            }
        }
        .task {
            await viewModel.loadCurrentLocationWeather()
            // Trigger staggered animations
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showWeatherCard = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.25)) {
                showDetailsCard = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
                showForecast = true
            }
        }
        .onChange(of: preferences.temperatureUnit) { _, _ in
            Task { @MainActor in
                await viewModel.refreshWeather()
            }
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            if newValue.isEmpty {
                showSearchResults = false
                viewModel.searchResults = []
            } else {
                Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // Debounce
                    if viewModel.searchText == newValue {
                        await viewModel.searchCities()
                        showSearchResults = true
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Good \(timeOfDay)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary.opacity(0.6))
                    Text("Glasscast")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                }
                Spacer()
                
                // Location Indicator
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                    Text(viewModel.currentWeather?.name ?? "Loading...")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.primary.opacity(0.7))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.primary.opacity(0.1))
                )
            }
            
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.primary.opacity(0.5))
                
                TextField("Search city...", text: $viewModel.searchText)
                    .foregroundColor(.primary)
                    .placeholder(when: viewModel.searchText.isEmpty) {
                        Text("Search city...").foregroundColor(.primary.opacity(0.3))
                    }
                
                if viewModel.isSearching {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.primary)
                } else if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                        showSearchResults = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.primary.opacity(0.5))
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primary.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Weather Card
    private func weatherCard(weather: WeatherData) -> some View {
        VStack(spacing: 8) {
            // Icon
            Image(systemName: weather.iconName)
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .primary.opacity(0.3), radius: 20)
                .floating(amplitude: 4, duration: 2.5)
            
            // Temperature
            Text(weather.temperatureString)
                .font(.system(size: 96, weight: .thin))
                .foregroundColor(.primary)
            
            // Condition
            Text(weather.conditionDescription)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary.opacity(0.8))
            
            // High/Low
            Text(weather.highLowString)
                .font(.system(size: 16))
                .foregroundColor(.primary.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.primary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Details Card
    private func detailsCard(weather: WeatherData) -> some View {
        HStack(spacing: 0) {
            detailItem(icon: "thermometer.medium", title: "Feels Like", value: "\(Int(round(weather.main.feelsLike)))°")
            
            Divider()
                .frame(height: 40)
                .background(Color.primary.opacity(0.2))
            
            detailItem(icon: "humidity.fill", title: "Humidity", value: "\(weather.main.humidity)%")
            
            Divider()
                .frame(height: 40)
                .background(Color.primary.opacity(0.2))
            
            detailItem(icon: "wind", title: "Wind", value: "\(Int(round(weather.wind.speed))) km/h")
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func detailItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "4763eb"))
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.primary.opacity(0.5))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Forecast Section
    private var forecastSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("5-Day Forecast")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.forecast) { day in
                        forecastCard(day: day)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func forecastCard(day: DailyForecast) -> some View {
        VStack(spacing: 12) {
            Text(day.dayName)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary.opacity(0.8))
            
            Image(systemName: day.icon)
                .font(.system(size: 24))
                .foregroundColor(.primary)
                .frame(height: 24)
            
            VStack(spacing: 2) {
                Text("\(Int(round(day.maxTemp)))°")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("\(Int(round(day.minTemp)))°")
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.5))
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

    
    // MARK: - Loading View
    private var loadingView: some View {
        ShimmerLoadingView(message: "Getting your location...")
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        GlassErrorView(message: message) {
            await viewModel.loadCurrentLocationWeather()
        }
    }
    
    // MARK: - Search Results Overlay
    private var searchResultsOverlay: some View {
        VStack {
            Spacer().frame(height: 180) // Below search bar
            
            VStack(spacing: 0) {
                ForEach(viewModel.searchResults) { city in
                    Button {
                        Task {
                            let success = await viewModel.addToFavorites(city)
                            if success {
                                HapticService.success()
                                viewModel.searchText = ""
                                showSearchResults = false
                            } else {
                                HapticService.error()
                            }
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(city.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text(city.displayName)
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Text("Add")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(hex: "4763eb"))
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color(hex: "4763eb"))
                            }
                        }
                        .padding()
                    }
                    
                    if city.id != viewModel.searchResults.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1a1a4e").opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color.black.opacity(0.3).ignoresSafeArea())
        .onTapGesture {
            showSearchResults = false
        }
    }
    
    // MARK: - Time of Day
    private var timeOfDay: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<21: return "Evening"
        default: return "Night"
        }
    }
}

#Preview {
    ZStack {
        PremiumBackground()
        HomeView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
