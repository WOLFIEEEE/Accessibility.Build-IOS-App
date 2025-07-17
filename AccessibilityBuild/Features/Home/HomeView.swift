import SwiftUI

/// Main home view with featured content and quick access to app sections
struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentFeature = 0
    @State private var isAnimating = false
    let scoreManager = GameScoreManager()
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.99, blue: 1.0),
                Color(red: 0.94, green: 0.97, blue: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private let featuredContent = [
        FeatureItem(
            title: "Contrast Hero",
            subtitle: "Master WCAG color contrast",
            description: "Test your knowledge of accessibility color requirements",
            icon: "eye.fill",
            color: Color.blue,
            action: "play_contrast_hero"
        ),
        FeatureItem(
            title: "Learning Center",
            subtitle: "Comprehensive guides",
            description: "Deep dive into accessibility fundamentals",
            icon: "book.fill",
            color: Color.green,
            action: "open_learn"
        ),
        FeatureItem(
            title: "Track Progress",
            subtitle: "See your growth",
            description: "Monitor your learning journey and achievements",
            icon: "chart.line.uptrend.xyaxis",
            color: Color.orange,
            action: "open_progress"
        )
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 28) {
                // Header Section
                headerSection
                
                // Featured Carousel
                featuredSection
                
                // Quick Stats
                quickStatsSection
                
                // Quick Actions
                quickActionsSection
                
                // Recent Activity
                recentActivitySection
                
                // Tips Section
                tipsSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationBarHidden(true)
        .background(
            colorScheme == .dark ? Color.black : backgroundGradient
        )
        .onAppear {
            startFeatureCarousel()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Home screen")
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // App branding
            HStack {
                ZStack {
                    Circle()
                        .fill(primaryGradient)
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.blue.opacity(0.3), radius: 15, x: 0, y: 8)
                    
                    Image(systemName: "accessibility")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                }
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .accessibleAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Accessibility.build")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(primaryGradient)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text("Learn. Play. Build Better.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            // Welcome message
            VStack(alignment: .leading, spacing: 12) {
                Text("Welcome back! Ready to continue your accessibility journey?")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Master web accessibility through interactive games and comprehensive learning resources.")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Featured")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            TabView(selection: $currentFeature) {
                ForEach(0..<featuredContent.count, id: \.self) { index in
                    FeatureCard(feature: featuredContent[index])
                        .tag(index)
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Your Progress")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
                
                NavigationLink(destination: ProgressView()) {
                    Text("View All")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.blue)
                }
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                QuickStatCard(
                    title: "Games Played",
                    value: "\(scoreManager.highScores.count)",
                    icon: "gamecontroller.fill",
                    color: .blue
                )
                
                QuickStatCard(
                    title: "Best Score",
                    value: bestScoreText,
                    icon: "star.fill",
                    color: .orange
                )
                
                QuickStatCard(
                    title: "Streak",
                    value: "7 days",
                    icon: "flame.fill",
                    color: .red
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Quick Actions")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ActionCard(
                    title: "Start Learning",
                    description: "Explore accessibility concepts",
                    icon: "book.fill",
                    color: .green,
                    destination: AnyView(LearnView())
                )
                
                ActionCard(
                    title: "Play Games",
                    description: "Test your knowledge",
                    icon: "gamecontroller.fill",
                    color: .blue,
                    destination: AnyView(GamesView())
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Recent Activity")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            if scoreManager.getRecentScores(limit: 3).isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    
                    Text("No recent activity")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text("Start playing games to see your activity here!")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 24)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(scoreManager.getRecentScores(limit: 3)) { score in
                        ActivityRow(score: score)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Tips Section
    private var tipsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Daily Tip")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.yellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Alt Text Best Practice")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("Keep alt text concise but descriptive. Focus on the purpose of the image, not just its appearance.")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.yellow.opacity(0.1))
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Helper Functions
    private func startFeatureCarousel() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentFeature = (currentFeature + 1) % featuredContent.count
            }
        }
    }
    
    private var bestScoreText: String {
        guard let bestScore = scoreManager.highScores.max(by: { $0.percentage < $1.percentage }) else {
            return "0%"
        }
        return "\(bestScore.percentage)%"
    }
}

// MARK: - Supporting Models and Components
struct FeatureItem {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let color: Color
    let action: String
}

struct FeatureCard: View {
    let feature: FeatureItem
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(feature.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(feature.color)
            }
            
            // Content
            VStack(spacing: 8) {
                Text(feature.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Text(feature.subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(feature.color)
                
                Text(feature.description)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(feature.title): \(feature.description)")
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

struct ActionCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(color)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(description)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .accessibleButton(
            action: title,
            hint: description
        )
    }
}

struct ActivityRow: View {
    let score: GameScore
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(scoreColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(score.gameName)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(formatDate(score.timestamp))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(score.formattedScore)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(scoreColor)
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(score.gameName) scored \(score.formattedScore) on \(formatDate(score.timestamp))")
    }
    
    private var scoreColor: Color {
        switch score.percentage {
        case 90...100: return .green
        case 70..<90: return .orange
        default: return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
} 