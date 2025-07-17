import Foundation

/// Model representing a game score
struct GameScore: Identifiable, Codable {
    let id = UUID()
    let gameName: String
    let score: Int
    let totalQuestions: Int
    let timestamp: Date
    
    var percentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(score) / Double(totalQuestions)) * 100)
    }
    
    var formattedScore: String {
        return "\(score)/\(totalQuestions) (\(percentage)%)"
    }
}

/// Manager for handling game scores and high scores
class GameScoreManager: ObservableObject {
    @Published var highScores: [GameScore] = []
    
    private let userDefaults = UserDefaults.standard
    private let scoresKey = "gameScores"
    
    init() {
        loadScores()
    }
    
    func saveScore(_ score: GameScore) {
        highScores.append(score)
        highScores.sort { $0.timestamp > $1.timestamp } // Most recent first
        saveScores()
    }
    
    func getBestScore(for gameName: String) -> GameScore? {
        return highScores
            .filter { $0.gameName == gameName }
            .max { $0.percentage < $1.percentage }
    }
    
    func getRecentScores(limit: Int = 5) -> [GameScore] {
        return Array(highScores.prefix(limit))
    }
    
    private func loadScores() {
        guard let data = userDefaults.data(forKey: scoresKey),
              let scores = try? JSONDecoder().decode([GameScore].self, from: data) else {
            return
        }
        highScores = scores
    }
    
    private func saveScores() {
        guard let data = try? JSONEncoder().encode(highScores) else { return }
        userDefaults.set(data, forKey: scoresKey)
    }
} 