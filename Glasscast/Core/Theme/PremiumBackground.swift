//
//  PremiumBackground.swift
//  Glasscast
//
//  Reusable premium animated background
//

import SwiftUI

struct PremiumBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Deep Base
            Color(hex: "050511").ignoresSafeArea()
            
            // Atmospheric Gradients
            GeometryReader { proxy in
                ZStack {
                    // Top Left Blue/Purple
                    Circle()
                        .fill(Color(hex: "4763eb").opacity(0.25))
                        .frame(width: 400, height: 400)
                        .blur(radius: 100)
                        .offset(x: animate ? -100 : -20, y: animate ? -150 : -50)
                    
                    // Bottom Right Purple/Pink
                    Circle()
                        .fill(Color(hex: "8A2BE2").opacity(0.2))
                        .frame(width: 400, height: 400)
                        .blur(radius: 120)
                        .offset(x: animate ? 200 : 100, y: animate ? 400 : 300)
                    
                    // Center Subtle Cyan
                    Circle()
                        .fill(Color(hex: "00bcd4").opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 100)
                        .offset(x: animate ? 50 : 200, y: animate ? 100 : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea()
            
            // Noise Texture Overlay (Optional, simulated with white opacity)
            Rectangle()
                .fill(Color.white.opacity(0.015))
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}
