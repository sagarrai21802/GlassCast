//
//  OTPVerificationView.swift
//  Glasscast
//
//  View for entering OTP code sent via email
//

import SwiftUI
import Combine

struct OTPVerificationView: View {
    @Bindable var viewModel: AuthViewModel
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 60
    
    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    // Prevent dismissing by tapping background for security
                    // OR allow dismissing if user wants to check email app?
                    // Better to keep it blocking until verified or cancelled.
                }
            
            // Glass Modal
            VStack(spacing: 24) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                        .frame(width: 72, height: 72)
                    
                    Image(systemName: "envelope.badge.shield.half.filled")
                        .font(.system(size: 32))
                        .foregroundColor(.primary)
                }
                
                VStack(spacing: 8) {
                    Text("Verify Email")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Enter the code sent to\n\(viewModel.email)")
                        .font(.subheadline)
                        .foregroundColor(.primary.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                
                // OTP Input
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPDigitBox(index: index, code: viewModel.otpCode)
                    }
                }
                .background(
                    // Hidden text field for input handling
                    TextField("", text: $viewModel.otpCode)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .foregroundColor(.clear)
                        .accentColor(.clear)
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                        .onChange(of: viewModel.otpCode) { _, newValue in
                            if newValue.count > 6 {
                                viewModel.otpCode = String(newValue.prefix(6))
                            }
                        }
                )
                .onTapGesture {
                    // Focus logic would go here if needed, but TextField is global
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                // Verify Button
                Button {
                    Task { await viewModel.verifyOtp() }
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
                        
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Verify")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 50)
                }
                .disabled(viewModel.otpCode.count < 6 || viewModel.isLoading)
                .opacity(viewModel.otpCode.count < 6 ? 0.6 : 1)
                
                // Resend Timer
                Button {
                    // Resend Logic
                    timeRemaining = 60
                } label: {
                    if timeRemaining > 0 {
                        Text("Resend code in \(timeRemaining)s")
                            .font(.caption)
                            .foregroundColor(.primary.opacity(0.4))
                    } else {
                        Text("Resend Code")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                .disabled(timeRemaining > 0)
                
                Button("Cancel") {
                    withAnimation {
                        viewModel.showOtpInput = false
                        viewModel.errorMessage = nil
                    }
                }
                .font(.footnote)
                .foregroundColor(.primary.opacity(0.5))
                .padding(.top, 8)
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
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}

struct OTPDigitBox: View {
    let index: Int
    let code: String
    
    private var char: String {
        if index < code.count {
            let start = code.index(code.startIndex, offsetBy: index)
            return String(code[start])
        }
        return ""
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
                .frame(width: 44, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color.primary.opacity(char.isEmpty ? 0.1 : 0.4),
                            lineWidth: 1
                        )
                )
            
            Text(char)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}
