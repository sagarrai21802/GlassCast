//
//  GlasscastApp.swift
//  Glasscast
//
//  Main App entry point
//

import SwiftUI
import Auth

@main
struct GlasscastApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force dark mode for glass effects
                .onOpenURL { url in
                    // Handle deep link from email confirmation
                    Task {
                        await handleDeepLink(url: url)
                    }
                }
        }
    }
    
    /// Handle incoming deep links (email confirmation, password reset, etc.)
    private func handleDeepLink(url: URL) async {
        // Parse the URL for auth callback
        // Supabase sends: glasscast://auth/callback#access_token=...
        guard url.scheme == "glasscast" else { return }
        
        do {
            // Let Supabase auth client handle the callback
            try await SupabaseService.shared.authClient.session(from: url)
            print("✅ Deep link handled successfully - user authenticated")
        } catch {
            print("❌ Deep link error: \(error.localizedDescription)")
        }
    }
}

