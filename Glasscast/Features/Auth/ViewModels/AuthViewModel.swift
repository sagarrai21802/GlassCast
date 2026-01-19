//
//  AuthViewModel.swift
//  Glasscast
//
//  ViewModel for authentication screen - handles sign in/sign up logic
//

import Foundation
import SwiftUI
import Combine

/// Authentication mode
enum AuthMode: String, CaseIterable {
    case signIn = "Sign In"
    case signUp = "Sign Up"
}

/// ViewModel for Auth Screen
@MainActor
@Observable
class AuthViewModel {
    // MARK: - Published Properties
    var authMode: AuthMode = .signIn
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isPasswordVisible: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
    var isAuthenticated: Bool = false
    var showEmailVerificationModal: Bool = false
    
    // MARK: - Computed Properties
    var isSignUp: Bool {
        authMode == .signUp
    }
    
    var isFormValid: Bool {
        let emailValid = !email.isEmpty && email.contains("@")
        let passwordValid = password.count >= 6
        
        if isSignUp {
            return emailValid && passwordValid && password == confirmPassword
        }
        return emailValid && passwordValid
    }
    
    var buttonTitle: String {
        isLoading ? "Loading..." : "Continue"
    }
    
    // MARK: - Actions
    func toggleAuthMode() {
        withAnimation(.easeInOut(duration: 0.3)) {
            authMode = authMode == .signIn ? .signUp : .signIn
            // Clear confirm password when switching modes
            confirmPassword = ""
            errorMessage = nil
        }
    }
    
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
    
    func authenticate() async {
        guard isFormValid else {
            errorMessage = isSignUp ?
                "Please fill all fields correctly" :
                "Please enter valid email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            if isSignUp {
                // Sign Up with Supabase
                try await SupabaseService.shared.signUp(email: email, password: password)
            } else {
                // Sign In with Supabase
                try await SupabaseService.shared.signIn(email: email, password: password)
            }
            
            // Check if authenticated
            if SupabaseService.shared.isAuthenticated {
                isAuthenticated = true
            } else if isSignUp {
                // For sign up, show email verification modal
                showEmailVerificationModal = true
            }
            
            isLoading = false
        } catch {
            isLoading = false
            // Parse Supabase error message
            errorMessage = parseAuthError(error)
        }
    }
    
    /// Parse authentication errors for user-friendly messages
    private func parseAuthError(_ error: Error) -> String {
        let errorString = error.localizedDescription.lowercased()
        
        if errorString.contains("invalid login credentials") || errorString.contains("invalid_credentials") {
            return "Invalid email or password"
        } else if errorString.contains("user already registered") || errorString.contains("already exists") {
            return "An account with this email already exists"
        } else if errorString.contains("email not confirmed") {
            return "Please verify your email before signing in"
        } else if errorString.contains("network") || errorString.contains("connection") {
            return "Network error. Please check your connection."
        } else {
            return "Authentication failed. Please try again."
        }
    }
    
    func signInWithApple() async {
        // TODO: Implement Apple Sign In
        print("Sign in with Apple tapped")
    }
    
    func signInWithGoogle() async {
        // TODO: Implement Google Sign In
        print("Sign in with Google tapped")
    }
    
    func forgotPassword() {
        // TODO: Implement forgot password flow
        print("Forgot password tapped for: \(email)")
    }
}
