//
//  SharedComponents.swift
//  Glasscast
//
//  Reusable UI components for loading states, errors, and empty states
//

import SwiftUI

// MARK: - Shimmer Loading View
struct ShimmerLoadingView: View {
    @State private var isAnimating = false
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated loader
            ZStack {
                Circle()
                    .stroke(Color.primary.opacity(0.1), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "4763eb"), Color(hex: "8A2BE2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            
            Text(message)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Skeleton Loading Placeholder
struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [
                        Color.primary.opacity(0.05),
                        Color.primary.opacity(0.1),
                        Color.primary.opacity(0.05)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                Color.primary.opacity(0.08),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 300 : -300)
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Error View
struct GlassErrorView: View {
    let title: String
    let message: String
    let retryAction: () async -> Void
    
    init(title: String = "Something went wrong", message: String, retryAction: @escaping () async -> Void) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Error Icon
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            // Retry Button
            Button {
                Task { await retryAction() }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "4763eb"), Color(hex: "8A2BE2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color(hex: "4763eb").opacity(0.4), radius: 10, y: 5)
                )
            }
            .buttonStyle(.pressable)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(.primary.opacity(0.3))
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "4763eb"))
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Network Error Overlay
struct NetworkErrorBanner: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .foregroundColor(.white)
            
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.9))
        )
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        PremiumBackground()
        VStack(spacing: 40) {
            ShimmerLoadingView(message: "Getting weather...")
            GlassErrorView(message: "Could not load weather data") {
                print("Retry")
            }
        }
    }
}
