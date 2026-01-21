//
//  AuthView.swift
//  Glasscast
//
//  Authentication Screen
//  Features: Premium Glassmorphism, animated background, refined inputs, and fluid animations.
//

import SwiftUI

/// Authentication View
struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    @Binding var isAuthenticated: Bool
    
    // Animation States
    @State private var appearContent = false
    
    var body: some View {
        ZStack {
            // MARK: - Animated Background
            PremiumBackground()
            
            // MARK: - Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header Section
                    AuthHeader()
                        .offset(y: appearContent ? 0 : -20)
                        .opacity(appearContent ? 1 : 0)
                    
                    // Segmented Control
                    PremiumSegmentedControl(selectedMode: $viewModel.authMode)
                        .padding(.top, 40)
                        .offset(y: appearContent ? 0 : 20)
                        .opacity(appearContent ? 1 : 0)
                    
                    // Form Section
                    AuthForm(viewModel: viewModel)
                        .padding(.top, 32)
                        .offset(y: appearContent ? 0 : 40)
                        .opacity(appearContent ? 1 : 0)
                    
                    // Footer / Social Login
                    
                        .padding(.top, 40)
                        .padding(.bottom, 24)
                        .opacity(appearContent ? 1 : 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                appearContent = true
            }
        }
        .onChange(of: viewModel.isAuthenticated) { _, newValue in
            if newValue {
                withAnimation {
                    isAuthenticated = true
                }
            }
        }
        .overlay {
            // Email Confirmation Message
            if viewModel.showOtpInput {
                EmailConfirmationView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.showOtpInput)
    }
}

// PremiumBackground moved to Core/Theme/PremiumBackground.swift

// MARK: - Header
struct AuthHeader: View {
    var body: some View {
        VStack(spacing: 20) {
            // Floating Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.primary.opacity(0.1), Color.primary.opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.primary.opacity(0.3), .clear, Color.primary.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color(hex: "4763eb").opacity(0.3), radius: 20, y: 10)
                
                Image(systemName: "cloud.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.primary, Color.primary.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color.primary.opacity(0.3), radius: 10)
            }
            
            VStack(spacing: 8) {
                Text("Glasscast")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .tracking(-1)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.primary, Color.primary.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                Text("Your premium weather companion")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary.opacity(0.5))
                    .tracking(0.5)
            }
        }
    }
}

// MARK: - Custom Segmented Control
struct PremiumSegmentedControl: View {
    @Binding var selectedMode: AuthMode
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AuthMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMode = mode
                    }
                } label: {
                    ZStack {
                        if selectedMode == mode {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .matchedGeometryEffect(id: "ActiveSegment", in: namespace)
                                .shadow(color: .black.opacity(0.1), radius: 2)
                        }
                        
                        Text(mode.rawValue)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(selectedMode == mode ? .primary : .primary.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                }
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.05))
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .frame(height: 50)
    }
    
    @Namespace private var namespace
}

// MARK: - Form
struct AuthForm: View {
    @Bindable var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Fields
            VStack(spacing: 16) {
                PremiumTextField(
                    icon: "envelope.fill",
                    placeholder: "Email Address",
                    text: $viewModel.email,
                    keyboardType: .emailAddress
                )
                
                PremiumSecureField(
                    icon: "lock.fill",
                    placeholder: "Password",
                    text: $viewModel.password,
                    isVisible: viewModel.isPasswordVisible,
                    onToggleVisibility: viewModel.togglePasswordVisibility
                )
                
                if viewModel.isSignUp {
                    PremiumSecureField(
                        icon: "lock.rotation",
                        placeholder: "Confirm Password",
                        text: $viewModel.confirmPassword,
                        isVisible: viewModel.isPasswordVisible,
                        onToggleVisibility: viewModel.togglePasswordVisibility
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.isSignUp)
            
            // Error Message
            if let error = viewModel.errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(error)
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "FF6B6B"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Forgot Password
            if !viewModel.isSignUp {
                Button {
                    viewModel.forgotPassword()
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "4763eb")) // Using primary color
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Action Button
            Button {
                HapticService.mediumImpact()
                Task { await viewModel.authenticate() }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "4763eb"), Color(hex: "8A2BE2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color(hex: "4763eb").opacity(0.4), radius: 15, y: 5)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(viewModel.isSignUp ? "Create Account" : "Sign In")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 56)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
            }
            .disabled(viewModel.isLoading)
            .padding(.top, 10)
        }
    }
}

// MARK: - Premium Inputs
struct PremiumTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isFocused ? .primary : .primary.opacity(0.5))
                .frame(width: 24)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.primary.opacity(0.3)))
                .foregroundColor(.primary)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isFocused)
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.primary.opacity(isFocused ? 0.1 : 0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            .primary.opacity(isFocused ? 0.5 : 0.1),
                            .primary.opacity(isFocused ? 0.2 : 0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

struct PremiumSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isVisible: Bool
    var onToggleVisibility: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isFocused ? .primary : .primary.opacity(0.5))
                .frame(width: 24)
            
            Group {
                if isVisible {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.primary.opacity(0.3)))
                } else {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.primary.opacity(0.3)))
                }
            }
            .foregroundColor(.primary)
            .focused($isFocused)
            
            Button(action: onToggleVisibility) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.primary.opacity(0.3))
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.primary.opacity(isFocused ? 0.1 : 0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            .primary.opacity(isFocused ? 0.5 : 0.1),
                            .primary.opacity(isFocused ? 0.2 : 0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Footer

#Preview {
    AuthView(isAuthenticated: .constant(false))
}
