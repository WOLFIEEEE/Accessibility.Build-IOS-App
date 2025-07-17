import SwiftUI

/// Main tab view for the app navigation
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Home")
            }
            .tag(0)
            
            // Games Tab
            NavigationStack {
                GamesView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "gamecontroller.fill" : "gamecontroller")
                Text("Games")
            }
            .tag(1)
            
            // Progress Tab
            NavigationStack {
                ProgressView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                Text("Progress")
            }
            .tag(2)
            
            // Learn Tab
            NavigationStack {
                LearnView()
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "book.fill" : "book")
                Text("Learn")
            }
            .tag(3)
            
            // Profile Tab
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                Text("Profile")
            }
            .tag(4)
        }
        .tint(Color(red: 0.2, green: 0.6, blue: 1.0))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Main navigation")
    }
}

#Preview {
    MainTabView()
} 