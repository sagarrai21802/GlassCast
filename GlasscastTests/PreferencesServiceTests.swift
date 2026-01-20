//
//  PreferencesServiceTests.swift
//  GlasscastTests
//
//  Unit tests for PreferencesService
//

import XCTest
@testable import Glasscast

final class PreferencesServiceTests: XCTestCase {
    
    var preferences: PreferencesService!
    
    override func setUp() {
        super.setUp()
        preferences = PreferencesService.shared
    }
    
    // MARK: - Temperature Unit Tests
    
    func testDefaultTemperatureUnit() {
        // Should have a valid default
        let unit = preferences.temperatureUnit
        XCTAssertTrue(
            unit == .celsius || unit == .fahrenheit,
            "Temperature unit should be either celsius or fahrenheit"
        )
    }
    
    func testTemperatureUnitPersistence() {
        // Save original
        let original = preferences.temperatureUnit
        
        // Change to opposite
        let newUnit: TemperatureUnit = original == .celsius ? .fahrenheit : .celsius
        preferences.temperatureUnit = newUnit
        
        // Verify change
        XCTAssertEqual(preferences.temperatureUnit, newUnit, "Temperature unit should be updated")
        
        // Verify persistence (read from UserDefaults directly)
        let savedValue = UserDefaults.standard.string(forKey: "temperatureUnit")
        XCTAssertEqual(savedValue, newUnit.id, "Temperature unit should be persisted in UserDefaults")
        
        // Restore original
        preferences.temperatureUnit = original
    }
    
    // MARK: - Theme Tests
    
    func testDefaultTheme() {
        let theme = preferences.theme
        XCTAssertTrue(
            theme == .system || theme == .light || theme == .dark,
            "Theme should be a valid AppTheme"
        )
    }
    
    func testThemePersistence() {
        // Save original
        let original = preferences.theme
        
        // Change theme
        preferences.theme = .dark
        XCTAssertEqual(preferences.theme, .dark, "Theme should be updated to dark")
        
        preferences.theme = .light
        XCTAssertEqual(preferences.theme, .light, "Theme should be updated to light")
        
        // Verify persistence
        let savedValue = UserDefaults.standard.string(forKey: "appTheme")
        XCTAssertEqual(savedValue, AppTheme.light.rawValue, "Theme should be persisted in UserDefaults")
        
        // Restore original
        preferences.theme = original
    }
    
    // MARK: - Temperature Display Tests
    
    func testTemperatureUnitDisplayNames() {
        XCTAssertEqual(TemperatureUnit.celsius.displayName, "Celsius (°C)")
        XCTAssertEqual(TemperatureUnit.fahrenheit.displayName, "Fahrenheit (°F)")
    }
    
    func testAppThemeDisplayNames() {
        XCTAssertEqual(AppTheme.system.displayName, "System")
        XCTAssertEqual(AppTheme.light.displayName, "Light")
        XCTAssertEqual(AppTheme.dark.displayName, "Dark")
    }
}
