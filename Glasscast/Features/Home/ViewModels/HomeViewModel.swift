//
//  HomeViewModel.swift
//  Glasscast
//
//  ViewModel for Home Screen
//

import SwiftUI
import Combine

@Observable
class HomeViewModel {
    var searchText: String = ""
    var isSearching: Bool = false
    var weather: Weather? // Placeholder type for now
    
    // Mock Data for UI building
    var currentCity: String = "San Francisco"
    var currentTemp: Int = 72
    var condition: String = "Partly Cloudy"
    
    func searchCity() {
        // TODO: Implement search
        print("Searching for: \(searchText)")
    }
}

// Temporary Type until we have full models
struct Weather {
    let id = UUID()
}
