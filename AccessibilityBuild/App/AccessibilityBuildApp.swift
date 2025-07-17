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