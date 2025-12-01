//
//  Onboarding.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 27.11.2025.
//

import SwiftUI

struct OnboardingData {
    let imageName: String
    let title: String
    let subtitle: String
}

struct Onboarding: View {
    @State private var currentPage: Int = 0
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    
    private let onboardingData: [OnboardingData] = [
        OnboardingData(
            imageName: "onboardingScreen_1",
            title: "Feel the weather inside you.",
            subtitle: "Discover what your emotions are trying\nto say."
        ),
        OnboardingData(
            imageName: "onboardingScreen_2",
            title: "Track your inner sky.",
            subtitle: "See patterns, reflect deeper, understand yourself better."
        ),
        OnboardingData(
            imageName: "onboardingScreen_3",
            title: "Every mood tells a story.",
            subtitle: "Capture your feelings and watch your journey unfold."
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Onboarding screen image (centered, 0.85 of screen height)
                Image(onboardingData[currentPage].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight * 0.85)
                
                Spacer()
            }
            
            // Bottom section with bottomFrame
            VStack {
                Spacer()
                
                ZStack {
                    // Bottom frame image
                    Image("bottomFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth)
                    
                    // Content on top of bottomFrame
                    VStack(spacing: screenHeight * 0.014) {
                        // Page indicators
                        HStack(spacing: screenWidth * 0.02) {
                            ForEach(0..<3) { index in
                                Image(index == currentPage ? "screenOn" : "screenOff")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth * 0.03, height: screenWidth * 0.03)
                            }
                        }
                        .padding(.top, screenHeight * 0.036)
                        
                        // Title text
                        Text(onboardingData[currentPage].title)
                            .font(.custom("Poppins-SemiBold", size: screenHeight * 0.024))
                            .foregroundColor(Color("text_1Color"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, screenWidth * 0.1)
                        
                        // Subtitle text
                        Text(onboardingData[currentPage].subtitle)
                            .font(.custom("Poppins-Regular", size: screenHeight * 0.019))
                            .foregroundColor(Color("text_2Color"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, screenWidth * 0.1)
                        
                        // Continue button
                        Button(action: {
                            if currentPage < 2 {
                                withAnimation(.spring(response: 0.3)) {
                                    currentPage += 1
                                }
                            } else {
                                // Last screen - go to MainMenu
                                nav.currentScreen = .MAIN
                            }
                        }) {
                            Image("continueButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.85)
                        }
                        .padding(.top, screenHeight * 0.014)
                        .padding(.bottom, screenHeight * 0.048)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    Onboarding()
}
