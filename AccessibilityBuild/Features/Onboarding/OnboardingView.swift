import SwiftUI

/// Comprehensive onboarding flow for new users
struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isCompleted = false
    @Environment(\.dismiss) private var dismiss
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Accessibility.build",
            subtitle: "Learn web accessibility through interactive games and tools",
            imageName: "accessibility",
            description: "Master the principles of inclusive design while having fun with educational mini-games.",
            primaryColor: Color(red: 0.2, green: 0.6, blue: 1.0)
        ),
        OnboardingPage(
            title: "Learn Through Play",
            subtitle: "Interactive games make learning accessibility fun",
            imageName: "gamecontroller.fill",
            description: "Test your knowledge with Contrast Hero and discover how color choices affect readability.",
            primaryColor: Color(red: 0.3, green: 0.7, blue: 0.9)
        ),
        OnboardingPage(
            title: "Track Your Progress",
            subtitle: "Monitor your learning journey and achievements",
            imageName: "chart.line.uptrend.xyaxis",
            description: "See your scores improve over time and unlock achievements as you master accessibility concepts.",
            primaryColor: Color(red: 0.1, green: 0.5, blue: 0.8)
        ),
        OnboardingPage(
            title: "Built for Everyone",
            subtitle: "Fully accessible design for all users",
            imageName: "heart.fill",
            description: "This app is designed with VoiceOver, Dynamic Type, and other accessibility features in mind.",
            primaryColor: Color(red: 0.4, green: 0.6, blue: 1.0)
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.99, blue: 1.0),
                        Color(red: 0.94, green: 0.97, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Skip button
                    HStack {
                        Spacer()
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .opacity(currentPage < pages.count - 1 ? 1 : 0)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Onboarding content
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .accessibleAnimation(.easeInOut(duration: 0.3), value: currentPage)
                    
                    // Bottom controls
                    VStack(spacing: 32) {
                        // Page indicator
                        HStack(spacing: 12) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage ? pages[currentPage].primaryColor : Color.gray.opacity(0.3))
                                    .frame(width: 10, height: 10)
                                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                    .accessibleAnimation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Page \(currentPage + 1) of \(pages.count)")
                        
                        // Action buttons
                        actionButtons
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Onboarding")
        .onChange(of: isCompleted) { _, completed in
            if completed {
                dismiss()
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            if currentPage > 0 {
                Button("Back") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage -= 1
                    }
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(pages[currentPage].primaryColor)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(pages[currentPage].primaryColor.opacity(0.1))
                )
                .accessibleButton(
                    action: "Go back to previous page",
                    hint: "Navigate to the previous onboarding screen"
                )
            }
            
            Button(currentPage == pages.count - 1 ? "Get Started" : "Continue") {
                if currentPage == pages.count - 1 {
                    completeOnboarding()
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                }
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(pages[currentPage].primaryColor)
                    .shadow(color: pages[currentPage].primaryColor.opacity(0.4), radius: 15, x: 0, y: 8)
            )
            .accessibleButton(
                action: currentPage == pages.count - 1 ? "Get started with the app" : "Continue to next page",
                hint: currentPage == pages.count - 1 ? "Complete onboarding and start using the app" : "Navigate to the next onboarding screen"
            )
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        isCompleted = true
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let description: String
    let primaryColor: Color
}

// MARK: - Individual Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.primaryColor.opacity(0.15))
                    .frame(width: 140, height: 140)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundStyle(page.primaryColor)
            }
            .accessibilityHidden(true)
            
            // Content
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(page.primaryColor)
                    .accessibilityAddTraits(.isHeader)
                
                Text(page.subtitle)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
} 