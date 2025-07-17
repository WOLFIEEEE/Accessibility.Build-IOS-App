import SwiftUI

struct ContentView: View {
    @State private var showingOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        Group {
            if showingOnboarding {
                OnboardingView()
                    .onAppear {
                        // Reset onboarding for demo purposes
                        // In production, remove this line
                        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                    }
            } else {
                MainTabView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("OnboardingCompleted"))) { _ in
            showingOnboarding = false
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Accessibility.build app")
    }
}

#Preview {
    ContentView()
} 