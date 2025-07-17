import SwiftUI

/// Progress tracking view showing user statistics and achievements
struct ProgressView: View {
    let scoreManager = GameScoreManager()
    @Environment(\.colorScheme) private var colorScheme
    
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
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Header
                headerSection
                
                // Statistics Overview
                statisticsSection
                
                // Recent Scores
                recentScoresSection
                
                // Achievements
                achievementsSection
                
                // Learning Streak
                streakSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
        .background(
            colorScheme == .dark ? Color.black : backgroundGradient
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Progress tracking")
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Your Learning Journey")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(primaryGradient)
                .accessibilityAddTraits(.isHeader)
            
            Text("Track your progress and celebrate your achievements in accessibility learning.")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.secondary.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Overview")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatisticCard(
                    title: "Games Played",
                    value: "\(scoreManager.highScores.count)",
                    icon: "gamecontroller.fill",
                    color: .blue
                )
                
                StatisticCard(
                    title: "Best Score",
                    value: bestScoreText,
                    icon: "star.fill",
                    color: .orange
                )
                
                StatisticCard(
                    title: "Accuracy",
                    value: overallAccuracyText,
                    icon: "target",
                    color: .green
                )
                
                StatisticCard(
                    title: "Learning Days",
                    value: "7",
                    icon: "calendar.badge.plus",
                    color: .purple
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
    
    // MARK: - Recent Scores Section
    private var recentScoresSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Recent Scores")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to detailed scores
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.blue)
            }
            
            if scoreManager.highScores.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    
                    Text("No games played yet")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text("Start playing games to see your progress here!")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 24)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(scoreManager.highScores.prefix(5)) { score in
                        ScoreRow(score: score)
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
    
    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Achievements")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                AchievementBadge(
                    title: "First Steps",
                    description: "Complete your first game",
                    icon: "star.fill",
                    isUnlocked: !scoreManager.highScores.isEmpty,
                    color: .yellow
                )
                
                AchievementBadge(
                    title: "Contrast Expert",
                    description: "Score 80% or higher",
                    icon: "eye.fill",
                    isUnlocked: scoreManager.highScores.contains { $0.percentage >= 80 },
                    color: .blue
                )
                
                AchievementBadge(
                    title: "Perfect Score",
                    description: "Get 100% on any game",
                    icon: "crown.fill",
                    isUnlocked: scoreManager.highScores.contains { $0.percentage == 100 },
                    color: .orange
                )
                
                AchievementBadge(
                    title: "Dedicated Learner",
                    description: "Play 5 games",
                    icon: "book.fill",
                    isUnlocked: scoreManager.highScores.count >= 5,
                    color: .green
                )
                
                AchievementBadge(
                    title: "Accessibility Champion",
                    description: "Master all concepts",
                    icon: "accessibility",
                    isUnlocked: false,
                    color: .purple
                )
                
                AchievementBadge(
                    title: "Coming Soon",
                    description: "More achievements",
                    icon: "plus.circle.fill",
                    isUnlocked: false,
                    color: .gray
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
    
    // MARK: - Streak Section
    private var streakSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Learning Streak")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("🔥")
                        .font(.system(size: 40))
                    
                    Text("Current Streak")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text("3 days")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 60)
                
                VStack(spacing: 8) {
                    Text("🏆")
                        .font(.system(size: 40))
                    
                    Text("Best Streak")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text("7 days")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Computed Properties
    private var bestScoreText: String {
        guard let bestScore = scoreManager.highScores.max(by: { $0.percentage < $1.percentage }) else {
            return "0%"
        }
        return "\(bestScore.percentage)%"
    }
    
    private var overallAccuracyText: String {
        guard !scoreManager.highScores.isEmpty else { return "0%" }
        let totalCorrect = scoreManager.highScores.reduce(0) { $0 + $1.score }
        let totalQuestions = scoreManager.highScores.reduce(0) { $0 + $1.totalQuestions }
        guard totalQuestions > 0 else { return "0%" }
        let accuracy = Int((Double(totalCorrect) / Double(totalQuestions)) * 100)
        return "\(accuracy)%"
    }
}

// MARK: - Supporting Components
struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

struct ScoreRow: View {
    let score: GameScore
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(scoreColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(score.gameName)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(formatDate(score.timestamp))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(score.formattedScore)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
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

struct AchievementBadge: View {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(isUnlocked ? color : .gray)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description). \(isUnlocked ? "Unlocked" : "Locked")")
    }
}

#Preview {
    NavigationStack {
        ProgressView()
    }
} 