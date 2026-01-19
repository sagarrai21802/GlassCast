//
//  SplashView.swift
//  Glasscast
//
//  Splash Screen - Converted from Google Stitch HTML design
//  Features: Animated glass emblem with cloud/sun icon, floating animation, ambient glow
//

import SwiftUI

/// Splash Screen View
struct SplashView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var pulseGlow = false
    
    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            GlasscastTheme.Gradients.background
                .ignoresSafeArea()
            
            // MARK: - Ambient Light Orb (Pulsing glow effect)
            Circle()
                .fill(GlasscastTheme.Colors.primary.opacity(0.1))
                .frame(width: 600, height: 600)
                .blur(radius: 120)
                .offset(y: -UIScreen.main.bounds.height * 0.15)
                .opacity(pulseGlow ? 0.6 : 0.3)
                .animation(
                    Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                    value: pulseGlow
                )
            
            // MARK: - Main Content (Floating)
            VStack(spacing: GlasscastTheme.Spacing.xl) {
                // Glass Emblem Container
                ZStack {
                    // Outer Glow Ring
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    GlasscastTheme.Colors.primary.opacity(0.3),
                                    Color.purple.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 168, height: 168)
                        .blur(radius: 20)
                        .opacity(isAnimating ? 0.6 : 0.4)
                    
                    // The Glass Circle
                    ZStack {
                        // Glass background
                        Circle()
                            .fill(GlasscastTheme.Gradients.glass)
                            .frame(width: 160, height: 160)
                        
                        // Glass border and shadow
                        Circle()
                            .stroke(GlasscastTheme.Colors.glassBorder, lineWidth: 1)
                            .frame(width: 160, height: 160)
                            .shadow(color: .black.opacity(0.5), radius: 25, y: 12)
                        
                        // Inner light effect
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.2), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                            .frame(width: 158, height: 158)
                        
                        // Icon Composition
                        ZStack {
                            // Sun Element (Behind)
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 36, weight: .light))
                                .foregroundColor(GlasscastTheme.Colors.sunYellow)
                                .offset(x: 20, y: -20)
                                .shadow(color: Color.yellow.opacity(0.3), radius: 15)
                            
                            // Cloud Element (Front)
                            Image(systemName: "cloud")
                                .font(.system(size: 60, weight: .ultraLight))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                        }
                        
                        // Subtle Reflection overlay
                        Ellipse()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 32, height: 16)
                            .blur(radius: 2)
                            .rotationEffect(.degrees(-45))
                            .offset(x: -30, y: -40)
                    }
                }
                .floatingAnimation(duration: 6, distance: 10)
                .scaleEffect(showContent ? 1.0 : 0.8)
                .opacity(showContent ? 1.0 : 0)
                
                // MARK: - Brand Typography
                VStack(spacing: GlasscastTheme.Spacing.sm) {
                    Text("Glasscast")
                        .font(.system(size: 40, weight: .ultraLight))
                        .tracking(8)
                        .foregroundColor(.white.opacity(0.9))
                        .textGlow()
                    
                    Text("PREMIUM WEATHER")
                        .font(.system(size: 12, weight: .medium))
                        .tracking(4)
                        .foregroundColor(GlasscastTheme.Colors.textMuted)
                }
                .opacity(showContent ? 1.0 : 0)
                .offset(y: showContent ? 0 : 20)
            }
            
            // MARK: - Footer Decorative Element
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: GlasscastTheme.CornerRadius.full)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 128, height: 2)
                    .opacity(0.2)
                    .padding(.bottom, 48)
            }
        }
        .onAppear {
            // Trigger animations
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                isAnimating = true
            }
            pulseGlow = true
        }
    }
}

#Preview {
    SplashView()
}
