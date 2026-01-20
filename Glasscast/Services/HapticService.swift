//
//  HapticService.swift
//  Glasscast
//
//  Haptic feedback utilities for tactile UI responses
//

import UIKit

/// Centralized haptic feedback service
enum HapticService {
    
    // MARK: - Impact Feedback
    
    /// Light impact - for subtle taps (tab bar, small buttons)
    static func lightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    /// Medium impact - for standard taps (cards, main buttons)
    static func mediumImpact() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    /// Heavy impact - for significant actions (long press, drag end)
    static func heavyImpact() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    /// Soft impact - modern subtle feedback
    static func softImpact() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    /// Rigid impact - sharp precise feedback
    static func rigidImpact() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
    // MARK: - Notification Feedback
    
    /// Success - action completed successfully (add favorite, sign in)
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    /// Warning - caution needed (delete confirmation, sign out)
    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    /// Error - something went wrong (network error, validation fail)
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    // MARK: - Selection Feedback
    
    /// Selection changed - for pickers, toggles, segmented controls
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
