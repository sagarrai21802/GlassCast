//
//  MainTabView.swift
//  Glasscast
//
//  Main Navigation Container holding Home, Favourites, and Settings
//

import SwiftUI

struct MainTabView: View {
    @Binding var isAuthenticated: Bool
    @State private var selectedTab: Tab = .home
    
    init(isAuthenticated: Binding<Bool>) {
        _isAuthenticated = isAuthenticated
        // Hide default TabBar
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            // Background Layer (Persistent across tabs)
            PremiumBackground()
            
            // Tab Content
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(Tab.home)
                
                FavouritesView()
                    .tag(Tab.favourites)
                
                SettingsView(isAuthenticated: $isAuthenticated)
                    .tag(Tab.settings)
            }
            
            // Custom Floating Tab Bar
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView(isAuthenticated: .constant(true))
}

