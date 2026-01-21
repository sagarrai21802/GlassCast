//
//  EmailConfirmationView.swift
//  Glasscast
//
//  Simple view showing email confirmation instructions
//

import SwiftUI

struct EmailConfirmationView: View {
    @Bindable var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Glass Modal
            VStack(spacing: 24) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                        .frame(width: 72, height: 72)
                    
                    Image(systemName: "envelope.badge")
                        .font(.system(size: 32))
                        .foregroundColor(.primary)
                }
                
                VStack(spacing: 8) {
                    Text("Check Your Email")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("We've sent a confirmation link to")
                        .font(.subheadline)
                        .foregroundColor(.primary.opacity(0.6))
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.email)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Text("Click the link in the email to verify your account, then come back here and sign in.")
                    .font(.footnote)
                    .foregroundColor(.primary.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Got It Button
                Button {
                    withAnimation {
                        viewModel.showOtpInput = false
                        viewModel.errorMessage = nil
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "4763eb"), Color(hex: "8A2BE2")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Got It")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 24)
        }
    }
}
