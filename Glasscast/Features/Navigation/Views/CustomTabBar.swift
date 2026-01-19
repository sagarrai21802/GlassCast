//
//  CustomTabBar.swift
//  Glasscast
//
//  Custom Glassmorphism Tab Bar
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case favourites = "Favourites"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .favourites: return "heart.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    // Namespace for animation
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 24))
                            .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                        
                        // Optional text or indicator
                        if selectedTab == tab {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 4, height: 4)
                                .matchedGeometryEffect(id: "TabIndicator", in: animation)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 4, height: 4)
                        }
                    }
                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.4))
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            ZStack {
                // Glass Background
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color(hex: "1a1a4e").opacity(0.6))
                    .blur(radius: 0)
                
                RoundedRectangle(cornerRadius: 32)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .white.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32))
            .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.home))
        }
    }
}
