//
//  SettingsView.swift
//  Glasscast
//
//  App settings and preferences
//

import SwiftUI
import Auth

struct SettingsView: View {
    @Binding var isAuthenticated: Bool
    @State private var showingSignOutAlert = false
    @State private var isLoading = false
    
    // Preferences
    @State private var temperatureUnit = PreferencesService.shared.temperatureUnit
    @State private var theme = PreferencesService.shared.theme
    
    // User Info
    @State private var userEmail: String? = SupabaseService.shared.currentUser?.email
    
    // Animation State
    @State private var showContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.top, 60)
                
                // Account Section
                SectionHeader(title: "Account")
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(userEmail ?? "User")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Text("Logged In")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .background(GlassContainer())
                
                // Preferences Section
                SectionHeader(title: "Preferences")
                
                VStack(spacing: 0) {
                    // Theme
                    HStack {
                        Image(systemName: "circle.lefthalf.filled")
                            .frame(width: 24)
                            .foregroundColor(.primary)
                        
                        Text("Appearance")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Picker("Theme", selection: $theme) {
                            ForEach(AppTheme.allCases) { theme in
                                Text(theme.displayName).tag(theme)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: theme) { _, newValue in
                            PreferencesService.shared.theme = newValue
                            HapticService.selection()
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.primary.opacity(0.1))
                    
                    // Temperature Unit
                    HStack {
                        Image(systemName: "thermometer")
                            .frame(width: 24)
                            .foregroundColor(.primary)
                        
                        Text("Temperature Unit")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Picker("Unit", selection: $temperatureUnit) {
                            ForEach(TemperatureUnit.allCases) { unit in
                                Text(unit.symbol).tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 120)
                        .onChange(of: temperatureUnit) { _, newValue in
                            PreferencesService.shared.temperatureUnit = newValue
                            HapticService.selection()
                            // Trigger refreshes elsewhere if needed
                            Task {
                                await HomeViewModel().refreshWeather()
                            }
                        }
                    }
                    .padding()
                }
                .background(GlassContainer())
                
                // Actions
                Button {
                    showingSignOutAlert = true
                    HapticService.warning()
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Sign Out")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white) // Keep Sign Out white on red
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red.opacity(0.8)) // Make more solid red/adaptive? Keep red.
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                }
                .padding(.top, 20)
                
                // Version
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.4))
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                signOut()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    private func signOut() {
        Task {
            do {
                try await SupabaseService.shared.signOut()
                withAnimation {
                    isAuthenticated = false
                }
            } catch {
                print("Error signing out: \(error)")
                // Force sign out locally regardless of error
                withAnimation {
                    isAuthenticated = false
                }
            }
        }
    }
}

// Helper Views
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary.opacity(0.6))
            Spacer()
        }
        .padding(.top, 8)
    }
}

struct GlassContainer: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.primary.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
    }
}


#Preview {
    ZStack {
        PremiumBackground()
        SettingsView(isAuthenticated: .constant(true))
    }
}
