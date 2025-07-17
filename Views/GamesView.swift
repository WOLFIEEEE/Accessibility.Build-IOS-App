import SwiftUI

/// Games list view displaying available accessibility-themed games
struct GamesView: View {
    let scoreManager = GameScoreManager()
    @Environment(\.colorScheme) private var colorScheme
    
    // Modern cool color palette
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
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Header
                headerSection
                
                // Games List
                ForEach(availableGames, id: \.name) { game in
                    GameCard(game: game, scoreManager: scoreManager)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .navigationTitle("Games")
        .navigationBarTitleDisplayMode(.large)
        .background(
            colorScheme == .dark ? Color.black : backgroundGradient
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Games list")
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Accessibility Games")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .accessibilityAddTraits(.isHeader)
            
            Text("Test your knowledge of web accessibility principles through these interactive games.")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.secondary.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Game Data Model
struct Game {
    let name: String
    let description: String
    let icon: String
    let difficulty: Difficulty
    let estimatedTime: String
    let destination: AnyView
    
    enum Difficulty: String, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var color: Color {
            switch self {
            case .beginner: return .green
            case .intermediate: return .orange
            case .advanced: return .red
            }
        }
    }
}

// MARK: - Available Games
private let availableGames = [
    Game(
        name: "Contrast Hero",
        description: "Test your knowledge of WCAG color contrast requirements. Can you identify which color combinations pass accessibility standards?",
        icon: "eye.fill",
        difficulty: .beginner,
        estimatedTime: "5-10 min",
        destination: AnyView(ContrastHeroView())
    ),
    Game(
        name: "Coming Soon: Alt Text Detective",
        description: "Help identify missing or poor alt text descriptions for images. Perfect for learning about image accessibility.",
        icon: "photo.fill",
        difficulty: .intermediate,
        estimatedTime: "10-15 min",
        destination: AnyView(ComingSoonView(gameName: "Alt Text Detective"))
    ),
    Game(
        name: "Coming Soon: Focus Flow",
        description: "Navigate through interfaces using only keyboard controls. Master the art of focus management and tab order.",
        icon: "keyboard.fill",
        difficulty: .advanced,
        estimatedTime: "15-20 min",
        destination: AnyView(ComingSoonView(gameName: "Focus Flow"))
    )
]

// MARK: - Game Card Component
struct GameCard: View {
    let game: Game
    let scoreManager: GameScoreManager
    @Environment(\.colorScheme) private var colorScheme
    
    private var cardGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white, Color.white.opacity(0.95)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
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
        VStack(alignment: .leading, spacing: 20) {
            // Header with icon, title, and difficulty
            HStack(alignment: .top, spacing: 16) {
                // Modern icon container
                ZStack {
                    Circle()
                        .fill(game.difficulty.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: game.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(game.difficulty.color)
                }
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Game Title
                    Text(game.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .accessibilityAddTraits(.isHeader)
                    
                    // Difficulty and Time Tags
                    HStack(spacing: 10) {
                        DifficultyTag(difficulty: game.difficulty)
                        TimeTag(time: game.estimatedTime)
                    }
                }
                
                Spacer()
            }
            
            // Description
            Text(game.description)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(Color.secondary.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .lineSpacing(2)
            
            // High Score Display (if available)
            if let highScore = scoreManager.getHighScore(for: game.name) {
                HighScoreDisplay(score: highScore)
            }
            
            // Play Button
            NavigationLink(destination: game.destination) {
                HStack(spacing: 12) {
                    if game.name.contains("Coming Soon") {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 16, weight: .medium))
                        Text("Coming Soon")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    } else {
                        Image(systemName: "play.fill")
                            .font(.system(size: 16, weight: .medium))
                        Text("Play Game")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .foregroundColor(game.name.contains("Coming Soon") ? .secondary : .white)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(game.name.contains("Coming Soon") ? Color.gray.opacity(0.2) : primaryGradient)
                        .shadow(
                            color: game.name.contains("Coming Soon") ? .clear : Color.blue.opacity(0.3),
                            radius: game.name.contains("Coming Soon") ? 0 : 15,
                            x: 0,
                            y: game.name.contains("Coming Soon") ? 0 : 5
                        )
                )
            }
            .disabled(game.name.contains("Coming Soon"))
            .accessibleButton(
                action: game.name.contains("Coming Soon") ? "Game coming soon" : "Play \(game.name)",
                hint: game.name.contains("Coming Soon") ? "This game is not yet available" : "Start playing \(game.name)"
            )
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : cardGradient)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
        )
        .gameElement(
            label: "\(game.name). \(game.difficulty.rawValue) difficulty. \(game.estimatedTime) estimated time.",
            value: game.description,
            hint: game.name.contains("Coming Soon") ? "Game not yet available" : "Tap to play this game"
        )
    }
}

// MARK: - Supporting Components
struct DifficultyTag: View {
    let difficulty: Game.Difficulty
    
    var body: some View {
        Text(difficulty.rawValue)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundColor(difficulty.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(difficulty.color.opacity(0.15))
            )
            .accessibilityLabel("Difficulty: \(difficulty.rawValue)")
    }
}

struct TimeTag: View {
    let time: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .font(.system(size: 10, weight: .medium))
            Text(time)
                .font(.system(size: 12, weight: .medium, design: .rounded))
        }
        .foregroundStyle(Color.secondary.opacity(0.8))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        )
        .accessibilityLabel("Estimated time: \(time)")
    }
}

struct HighScoreDisplay: View {
    let score: GameScore
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "trophy.fill")
                .font(.caption)
                .foregroundStyle(.yellow)
            
            Text("Best: \(score.formattedScore)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("High score: \(score.formattedScore)")
    }
}

// MARK: - Coming Soon Placeholder View
struct ComingSoonView: View {
    let gameName: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
                .accessibilityHidden(true)
            
            Text("\(gameName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            
            Text("This game is currently under development. Check back soon for more accessibility-themed fun!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Button("Back to Games") {
                // Navigation will handle this automatically
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 200, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
            )
            .accessibleButton(action: "Back to Games", hint: "Return to the games list")
        }
        .padding(32)
        .navigationTitle(gameName)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        GamesView()
    }
}

#Preview("Coming Soon") {
    NavigationStack {
        ComingSoonView(gameName: "Alt Text Detective")
    }
} 