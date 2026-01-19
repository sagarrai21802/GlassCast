//
//  ContentView.swift
//  Glasscast
//
//  Main content view that manages app navigation flow
//  Flow: Splash → Auth → Main App
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash: Bool = false  // Set to false to skip splash
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        ZStack {
            if showSplash {
                // Splash Screen
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        // Navigate to Auth after 2.5 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showSplash = false
                            }
                        }
                    }
            } else if !isAuthenticated {
                // Auth Screen
                AuthView(isAuthenticated: $isAuthenticated)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                // Main App Navigation
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showSplash)
        .animation(.easeInOut(duration: 0.4), value: isAuthenticated)
    }
}

#Preview {
    ContentView()
}
