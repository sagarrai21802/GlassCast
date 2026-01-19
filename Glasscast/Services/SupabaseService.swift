//
//  SupabaseService.swift
//  Glasscast
//
//  Supabase client for authentication and database operations
//

import Foundation
import Auth
import PostgREST

/// Singleton service for Supabase operations
@MainActor
class SupabaseService {
    static let shared = SupabaseService()
    
    // MARK: - Configuration
    private let supabaseURL = URL(string: "https://eoidtvgddtxjjjaahmbe.supabase.co")!
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvaWR0dmdkZHR4ampqYWFobWJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4MjAyMzEsImV4cCI6MjA4NDM5NjIzMX0.x1fbFnx2dB54N86VNDwki9NitpcVL1uiM28iOejwc1s"
    
    // MARK: - Clients
    let authClient: AuthClient
    
    var postgrestClient: PostgrestClient {
        var headers = ["apikey": supabaseKey]
        if let token = authClient.currentSession?.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        } else {
            headers["Authorization"] = "Bearer \(supabaseKey)"
        }
        
        return PostgrestClient(
            url: supabaseURL.appendingPathComponent("rest/v1"),
            schema: "public",
            headers: headers
        )
    }
    
    private init() {
        // Initialize Auth client
        authClient = AuthClient(
            configuration: AuthClient.Configuration(
                url: supabaseURL.appendingPathComponent("auth/v1"),
                headers: ["apikey": supabaseKey, "Authorization": "Bearer \(supabaseKey)"],
                localStorage: KeychainLocalStorage()
            )
        )
    }
    
    // MARK: - Authentication
    
    /// Sign up a new user with email and password
    func signUp(email: String, password: String) async throws {
        try await authClient.signUp(email: email, password: password)
    }
    
    /// Sign in an existing user with email and password
    func signIn(email: String, password: String) async throws {
        try await authClient.signIn(email: email, password: password)
    }
    
    /// Verify OTP for email verification (Sign Up)
    func verifySignupOtp(email: String, token: String) async throws {
        try await authClient.verifyOTP(email: email, token: token, type: .signup)
    }
    
    /// Restore session from storage
    func restoreSession() async {
        _ = try? await authClient.session
    }
    
    /// Sign out the current user
    func signOut() async throws {
        try await authClient.signOut()
    }
    
    /// Get the current authenticated user
    var currentUser: User? {
        authClient.currentUser
    }
    
    /// Check if user is authenticated
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    /// Get the current session
    var currentSession: Session? {
        authClient.currentSession
    }
}

// MARK: - In-Memory Storage
final class InMemoryLocalStorage: AuthLocalStorage, @unchecked Sendable {
    private var storage: [String: Data] = [:]
    private let lock = NSLock()
    
    func store(key: String, value: Data) throws {
        lock.lock()
        defer { lock.unlock() }
        storage[key] = value
    }
    
    func retrieve(key: String) throws -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return storage[key]
    }
    
    func remove(key: String) throws {
        lock.lock()
        defer { lock.unlock() }
        storage.removeValue(forKey: key)
    }
}


