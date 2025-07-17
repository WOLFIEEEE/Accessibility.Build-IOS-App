import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Accessibility.build app")
    }
}

#Preview {
    ContentView()
} 