//
//  GlasscastApp.swift
//  Glasscast
//
//  Main App entry point
//

import SwiftUI

@main
struct GlasscastApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force dark mode for glass effects
        }
    }
}
