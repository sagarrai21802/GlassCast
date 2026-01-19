//
//  SupabaseService.swift
//  Glasscast
//
//  Supabase client for authentication and database operations
//

import Foundation
import Supabase

/// Singleton service for Supabase operations
@MainActor
class SupabaseService {
    static let shared = SupabaseService()
    
    // MARK: - Supabase Client
    let client: SupabaseClient
    
    private init() {
        // Initialize Supabase client with project credentials
        client = SupabaseClient(
            supabaseURL: URL(string: "https://eoidtvgddtxjjjaahmbe.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvaWR0dmdkZHR4ampqYWFobWJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4MjAyMzEsImV4cCI6MjA4NDM5NjIzMX0.x1fbFnx2dB54N86VNDwki9NitpcVL1uiM28iOejwc1s"
        )
    }
    
    // MARK: - Authentication
    
    /// Sign up a new user with email and password
    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
    }
    
    /// Sign in an existing user with email and password
    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }
    
    /// Sign out the current user
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    /// Get the current authenticated user
    var currentUser: User? {
        client.auth.currentUser
    }
    
    /// Check if user is authenticated
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    /// Get the current session
    var currentSession: Session? {
        client.auth.currentSession
    }
}
