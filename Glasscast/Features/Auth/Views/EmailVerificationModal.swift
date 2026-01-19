//
//  EmailVerificationModal.swift
//  Glasscast
//
//  Beautiful modal shown after user signs up - prompts email verification
//

import SwiftUI

struct EmailVerificationModal: View {
    let email: String
    let onDismiss: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Modal Content
            VStack(spacing: 28) {
                // Success Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "4763eb").opacity(0.3), Color(hex: "8A2BE2").opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .stroke(Color(hex: "4763eb").opacity(0.5), lineWidth: 2)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "envelope.badge.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .white.opacity(0.3), radius: 10)
                }
                .scaleEffect(animate ? 1 : 0.5)
                .opacity(animate ? 1 : 0)
                
                // Title
                VStack(spacing: 12) {
                    Text("Check Your Email")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("We've sent a verification link to")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text(email)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "4763eb"))
                }
                .multilineTextAlignment(.center)
                .offset(y: animate ? 0 : 20)
                .opacity(animate ? 1 : 0)
                
                // Instructions
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(Color(hex: "4763eb"))
                        Text("Open your email inbox")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .font(.system(size: 14))
                    
                    HStack(spacing: 10) {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(Color(hex: "4763eb"))
                        Text("Click the verification link")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .font(.system(size: 14))
                    
                    HStack(spacing: 10) {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(Color(hex: "4763eb"))
                        Text("Come back and sign in")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .font(.system(size: 14))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .offset(y: animate ? 0 : 30)
                .opacity(animate ? 1 : 0)
                
                // Button
                Button {
                    onDismiss()
                } label: {
                    Text("Got it!")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "4763eb"), Color(hex: "8A2BE2")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: Color(hex: "4763eb").opacity(0.4), radius: 10, y: 5)
                }
                .offset(y: animate ? 0 : 40)
                .opacity(animate ? 1 : 0)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(hex: "0d0d2b"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 30, y: 20)
            )
            .padding(.horizontal, 24)
            .scaleEffect(animate ? 1 : 0.9)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                animate = true
            }
        }
    }
}

#Preview {
    EmailVerificationModal(email: "test@example.com") { }
}
