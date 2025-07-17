import SwiftUI

@main
struct AccessibilityBuildApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil) // Supports system dark mode
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Accessibility.build app")
    }
} 