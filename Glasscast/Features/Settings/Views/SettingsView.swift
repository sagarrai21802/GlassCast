//
//  SettingsView.swift
//  Glasscast
//
//  App settings and preferences
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.thin)
                .foregroundColor(.white)
            
            Text("Preferences and account settings.")
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SettingsView()
    }
}
