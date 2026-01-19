//
//  GlassEffects.swift
//  Glasscast
//
//  Reusable glass effect modifiers for glassmorphism UI
//

import SwiftUI

/// Floating animation modifier for splash screen elements
struct FloatingAnimationModifier: ViewModifier {
    @State private var isFloating = false
    let duration: Double
    let distance: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -distance : 0)
            .animation(
                Animation.easeInOut(duration: duration).repeatForever(autoreverses: true),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
}

// MARK: - View Extensions
extension View {
    /// Apply floating animation
    func floatingAnimation(duration: Double = 6.0, distance: CGFloat = 10) -> some View {
        self.modifier(FloatingAnimationModifier(duration: duration, distance: distance))
    }
    
    /// Text glow effect
    func textGlow(color: Color = .white, radius: CGFloat = 20) -> some View {
        self.shadow(color: color.opacity(0.1), radius: radius)
    }
}
