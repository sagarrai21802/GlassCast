//
//  WeatherService.swift
//  Glasscast
//
//  Service for fetching weather data from OpenWeatherMap API
//

import Foundation

/// Weather data model
struct WeatherData: Codable {
    let coord: Coordinates
    let weather: [WeatherCondition]
    let main: MainWeather
    let wind: Wind
    let name: String
    let sys: Sys
    
    struct Coordinates: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct WeatherCondition: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Int
        let pressure: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
            case pressure
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int?
    }
    
    struct Sys: Codable {
        let country: String?
        let sunrise: Int
        let sunset: Int
    }
}

/// City search result model
struct CitySearchResult: Codable, Identifiable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    var id: String { "\(name)-\(lat)-\(lon)" }
    var displayName: String {
        if let state = state {
            return "\(name), \(state), \(country)"
        }
        return "\(name), \(country)"
    }
}

/// Weather Service for API calls
class WeatherService {
    static let shared = WeatherService()
    
    // MARK: - Configuration (Loaded from Keychain)
    private var apiKey: String {
        SecureKeyStorage.shared.openWeatherAPIKey
    }
    
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let geoURL = "https://api.openweathermap.org/geo/1.0"
    
    private init() {}
    
    // MARK: - Fetch Weather by Coordinates
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        let unit = PreferencesService.shared.temperatureUnit.id
        let urlString = "\(baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=\(unit)"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(WeatherData.self, from: data)
    }
    
    // MARK: - Fetch Weather by City Name
    func fetchWeather(city: String) async throws -> WeatherData {
        let unit = PreferencesService.shared.temperatureUnit.id
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "\(baseURL)/weather?q=\(encodedCity)&appid=\(apiKey)&units=\(unit)"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(WeatherData.self, from: data)
    }
    
    // MARK: - Search Cities
    func searchCities(query: String) async throws -> [CitySearchResult] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(geoURL)/direct?q=\(encodedQuery)&limit=5&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([CitySearchResult].self, from: data)
    }
    
    // MARK: - Fetch 5-Day Forecast
    func fetchForecast(lat: Double, lon: Double) async throws -> [ForecastItem] {
        let unit = PreferencesService.shared.temperatureUnit.id
        let urlString = "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=\(unit)"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let responseData = try decoder.decode(ForecastResponse.self, from: data)
        return responseData.list
    }
}

// MARK: - Forecast Models
struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable, Identifiable {
    let dt: TimeInterval
    let main: WeatherData.MainWeather
    let weather: [WeatherData.WeatherCondition]
    
    var id: TimeInterval { dt }
    var date: Date { Date(timeIntervalSince1970: dt) }
}

extension ForecastItem {
    var iconName: String {
        guard let condition = weather.first else { return "cloud.fill" }
        
        switch condition.icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
    
    var temperatureString: String {
        "\(Int(round(main.temp)))°"
    }
}

// MARK: - Errors
enum WeatherError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Failed to fetch weather data"
        case .decodingError: return "Failed to parse weather data"
        }
    }
}

// MARK: - Weather Icon Helper
extension WeatherData {
    var iconName: String {
        guard let condition = weather.first else { return "cloud.fill" }
        
        switch condition.icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
    
    var conditionDescription: String {
        weather.first?.description.capitalized ?? "Unknown"
    }
    
    var temperatureString: String {
        "\(Int(round(main.temp)))°"
    }
    
    var highLowString: String {
        "H:\(Int(round(main.tempMax)))° L:\(Int(round(main.tempMin)))°"
    }
}
