//
//  FavouritesView.swift
//  Glasscast
//
//  Display list of favorite cities
//

import SwiftUI

struct FavouritesView: View {
    var body: some View {
        VStack {
            Text("Favourites")
                .font(.largeTitle)
                .fontWeight(.thin)
                .foregroundColor(.white)
            
            Text("Your saved cities will appear here.")
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FavouritesView()
    }
}
