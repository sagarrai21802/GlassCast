//
//  SecureKeyStorage.swift
//  Glasscast
//
//  Secure storage for API keys using Keychain
//

import Foundation
import Security

/// Keys for secure storage
enum SecureStorageKey: String {
    case supabaseURL = "com.glasscast.supabase.url"
    case supabaseAnonKey = "com.glasscast.supabase.anonkey"
    case openWeatherAPIKey = "com.glasscast.openweather.apikey"
}

/// Secure storage service for API keys using Keychain
final class SecureKeyStorage {
    static let shared = SecureKeyStorage()
    
    private let service = "com.brewapps.glasscast.keys"
    
    private init() {
        // Initialize with default keys on first launch
        initializeDefaultKeysIfNeeded()
    }
    
    // MARK: - Public API
    
    /// Save a string value to Keychain
    func save(key: SecureStorageKey, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: service,
            kSecValueData as String: data
        ]
        
        // Delete existing item if any
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Retrieve a string value from Keychain
    func retrieve(key: SecureStorageKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: service,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    /// Delete a key from Keychain
    func delete(key: SecureStorageKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    // MARK: - Convenience Getters
    
    var supabaseURL: String {
        retrieve(key: .supabaseURL) ?? ""
    }
    
    var supabaseAnonKey: String {
        retrieve(key: .supabaseAnonKey) ?? ""
    }
    
    var openWeatherAPIKey: String {
        retrieve(key: .openWeatherAPIKey) ?? ""
    }
    
    // MARK: - First Launch Setup
    
    /// Initialize default keys on first launch
    /// These are the development keys - in production, use a secure onboarding flow
    private func initializeDefaultKeysIfNeeded() {
        // Check if keys already exist
        if retrieve(key: .supabaseURL) == nil {
            _ = save(key: .supabaseURL, value: Keys.supabaseURL)
        }
        
        if retrieve(key: .supabaseAnonKey) == nil {
            _ = save(key: .supabaseAnonKey, value: Keys.supabaseAnonKey)
        }
        
        if retrieve(key: .openWeatherAPIKey) == nil {
            _ = save(key: .openWeatherAPIKey, value: Keys.openWeatherAPIKey)
        }
    }
}
