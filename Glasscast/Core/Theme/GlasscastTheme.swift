//
//  GlasscastTheme.swift
//  Glasscast
//
//  Design tokens and color palette from Google Stitch design
//

import SwiftUI

/// Glasscast Theme - Design tokens and color palette
struct GlasscastTheme {
    
    // MARK: - Colors
    struct Colors {
        // Primary
        static let primary = Color(hex: "5e8eed")
        
        // Background
        static let backgroundDark = Color(hex: "111621")
        static let deepNavy = Color(hex: "0F1219")
        static let richPurple = Color(hex: "1E1B2E")
        
        // Gradient colors
        static let gradientStart = Color(hex: "0a0e17")
        static let gradientMiddle = Color(hex: "161b2e")
        static let gradientEnd = Color(hex: "241e33")
        
        // Text
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        static let textMuted = Color.white.opacity(0.4)
        
        // Glass
        static let glassBackground = Color.white.opacity(0.08)
        static let glassBorder = Color.white.opacity(0.08)
        static let glassHighlight = Color.white.opacity(0.1)
        
        // Accents
        static let sunYellow = Color(hex: "FDE047").opacity(0.8)
        static let errorRed = Color(hex: "EF4444")
        static let successGreen = Color(hex: "22C55E")
    }
    
    // MARK: - Gradients
    struct Gradients {
        static let background = LinearGradient(
            colors: [Colors.gradientStart, Colors.gradientMiddle, Colors.gradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let glass = LinearGradient(
            colors: [Color.white.opacity(0.1), Color.white.opacity(0.03)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let primaryButton = LinearGradient(
            colors: [Colors.primary, Color(hex: "8B5CF6")],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let ambientGlow = RadialGradient(
            colors: [Colors.primary.opacity(0.15), Color.clear],
            center: .center,
            startRadius: 0,
            endRadius: 300
        )
    }
    
    // MARK: - Typography
    struct Typography {
        static let displayLarge = Font.system(size: 40, weight: .ultraLight)
        static let displayMedium = Font.system(size: 32, weight: .light)
        static let headline = Font.system(size: 24, weight: .semibold)
        static let title = Font.system(size: 20, weight: .medium)
        static let body = Font.system(size: 16, weight: .regular)
        static let caption = Font.system(size: 12, weight: .medium)
        static let small = Font.system(size: 10, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 9999
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
