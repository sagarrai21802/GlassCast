//
//  AnimationStyles.swift
//  Glasscast
//
//  Reusable animation styles and modifiers for consistent UI feedback
//

import SwiftUI

// MARK: - Press Effect Button Style
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Bounce Animation Button Style
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: configuration.isPressed)
    }
}

// MARK: - Floating Animation Modifier
struct FloatingModifier: ViewModifier {
    @State private var isAnimating = false
    let amplitude: CGFloat
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? amplitude : -amplitude)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Pulse Animation Modifier
struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    let scale: CGFloat
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? scale : 1.0)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

// MARK: - View Extensions
extension View {
    func floating(amplitude: CGFloat = 3, duration: Double = 2) -> some View {
        modifier(FloatingModifier(amplitude: amplitude, duration: duration))
    }
    
    func pulsing(scale: CGFloat = 1.05, duration: Double = 1.5) -> some View {
        modifier(PulseModifier(scale: scale, duration: duration))
    }
}

// MARK: - Button Style Extension
extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { PressableButtonStyle() }
}

extension ButtonStyle where Self == BounceButtonStyle {
    static var bounce: BounceButtonStyle { BounceButtonStyle() }
}
