//
//  SecureKeyStorageTests.swift
//  GlasscastTests
//
//  Unit tests for SecureKeyStorage
//

import XCTest
@testable import Glasscast

final class SecureKeyStorageTests: XCTestCase {
    
    var storage: SecureKeyStorage!
    
    override func setUp() {
        super.setUp()
        storage = SecureKeyStorage.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Supabase Keys Tests
    
    func testSupabaseURLExists() {
        let url = storage.supabaseURL
        XCTAssertFalse(url.isEmpty, "Supabase URL should not be empty")
        XCTAssertTrue(url.contains("supabase.co"), "Supabase URL should contain supabase.co")
    }
    
    func testSupabaseAnonKeyExists() {
        let key = storage.supabaseAnonKey
        XCTAssertFalse(key.isEmpty, "Supabase anon key should not be empty")
        XCTAssertTrue(key.hasPrefix("eyJ"), "Supabase key should be a JWT (starts with eyJ)")
    }
    
    // MARK: - OpenWeather Key Tests
    
    func testOpenWeatherAPIKeyExists() {
        let key = storage.openWeatherAPIKey
        XCTAssertFalse(key.isEmpty, "OpenWeather API key should not be empty")
        XCTAssertEqual(key.count, 32, "OpenWeather API key should be 32 characters")
    }
    
    // MARK: - Save and Retrieve Tests
    
    func testSaveAndRetrieveCustomKey() {
        // Create a test key
        let testKey = SecureStorageKey.openWeatherAPIKey
        let originalValue = storage.retrieve(key: testKey)
        
        // Save a test value
        let testValue = "test_api_key_12345"
        let saveResult = storage.save(key: testKey, value: testValue)
        XCTAssertTrue(saveResult, "Save should succeed")
        
        // Retrieve and verify
        let retrieved = storage.retrieve(key: testKey)
        XCTAssertEqual(retrieved, testValue, "Retrieved value should match saved value")
        
        // Restore original value
        if let original = originalValue {
            _ = storage.save(key: testKey, value: original)
        }
    }
    
    func testDeleteKey() {
        let testKey = SecureStorageKey.openWeatherAPIKey
        let originalValue = storage.retrieve(key: testKey)
        
        // Save a value first
        _ = storage.save(key: testKey, value: "temp_value")
        
        // Delete it
        let deleteResult = storage.delete(key: testKey)
        XCTAssertTrue(deleteResult, "Delete should succeed")
        
        // Verify it's gone
        let retrieved = storage.retrieve(key: testKey)
        XCTAssertNil(retrieved, "Key should be nil after deletion")
        
        // Restore original
        if let original = originalValue {
            _ = storage.save(key: testKey, value: original)
        }
    }
}
