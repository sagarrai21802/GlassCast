//
//  WeatherServiceTests.swift
//  GlasscastTests
//
//  Unit tests for WeatherService
//

import XCTest
@testable import Glasscast

final class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    
    override func setUp() {
        super.setUp()
        weatherService = WeatherService.shared
    }
    
    // MARK: - API Key Tests
    
    func testAPIKeyIsLoaded() {
        // The API key should be loaded from SecureKeyStorage
        let key = SecureKeyStorage.shared.openWeatherAPIKey
        XCTAssertFalse(key.isEmpty, "API key should be loaded from Keychain")
    }
    
    // MARK: - Weather Data Model Tests
    
    func testWeatherDataDecoding() throws {
        // JSON must match the CodingKeys in the model exactly
        let json = """
        {
            "coord": {"lon": -0.1257, "lat": 51.5085},
            "weather": [{"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}],
            "main": {"temp": 20.5, "feels_like": 19.8, "temp_min": 18.0, "temp_max": 22.0, "humidity": 65, "pressure": 1013},
            "wind": {"speed": 3.5},
            "name": "London",
            "sys": {"country": "GB", "sunrise": 1700000000, "sunset": 1700040000}
        }
        """.data(using: .utf8)!
        
        // Model has custom CodingKeys, so use default decoder
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: json)
        
        XCTAssertEqual(weatherData.name, "London")
        XCTAssertEqual(weatherData.main.temp, 20.5)
        XCTAssertEqual(weatherData.main.humidity, 65)
        XCTAssertEqual(weatherData.weather.first?.main, "Clear")
        XCTAssertEqual(weatherData.sys.country, "GB")
    }
    
    func testWeatherIconMapping() throws {
        let json = """
        {
            "coord": {"lon": 0, "lat": 0},
            "weather": [{"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}],
            "main": {"temp": 20, "feels_like": 20, "temp_min": 20, "temp_max": 20, "humidity": 50, "pressure": 1000},
            "wind": {"speed": 0},
            "name": "Test",
            "sys": {"country": "XX", "sunrise": 1700000000, "sunset": 1700040000}
        }
        """.data(using: .utf8)!
        
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: json)
        
        // Test icon name mapping
        XCTAssertEqual(weatherData.iconName, "sun.max.fill", "Clear weather should map to sun icon")
    }
    
    // MARK: - City Search Model Tests
    
    func testCitySearchResultDecoding() throws {
        let json = """
        [
            {"name": "London", "lat": 51.5085, "lon": -0.1257, "country": "GB", "state": "England"}
        ]
        """.data(using: .utf8)!
        
        let results = try JSONDecoder().decode([CitySearchResult].self, from: json)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "London")
        XCTAssertEqual(results.first?.country, "GB")
        XCTAssertEqual(results.first?.state, "England")
    }
    
    // MARK: - Forecast Model Tests
    
    func testForecastDataDecoding() throws {
        let json = """
        {
            "list": [
                {
                    "dt": 1700000000,
                    "main": {"temp": 15.0, "feels_like": 14.0, "temp_min": 10.0, "temp_max": 20.0, "humidity": 70, "pressure": 1015},
                    "weather": [{"id": 500, "main": "Rain", "description": "light rain", "icon": "10d"}]
                }
            ]
        }
        """.data(using: .utf8)!
        
        let forecast = try JSONDecoder().decode(ForecastResponse.self, from: json)
        
        XCTAssertEqual(forecast.list.count, 1)
        XCTAssertEqual(forecast.list.first?.main.temp, 15.0)
    }
    
    // NOTE: Integration tests removed - they require network access and Keychain
    // which causes simulator instability. Use UI tests for end-to-end testing.
}
