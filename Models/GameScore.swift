import Foundation

/// Model for storing game scores locally using UserDefaults
struct GameScore: Codable, Identifiable {
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
        "\(score)/\(totalQuestions) (\(percentage)%)"
    }
}

/// Manager class for handling game score persistence
@Observable
final class GameScoreManager {
    private let userDefaults = UserDefaults.standard
    private let scoresKey = "accessibility_build_scores"
    
    var highScores: [GameScore] = []
    
    init() {
        loadScores()
    }
    
    /// Save a new game score
    func saveScore(_ score: GameScore) {
        highScores.append(score)
        // Keep only the top 10 scores per game
        highScores = highScores
            .filter { $0.gameName == score.gameName }
            .sorted { $0.score > $1.score }
            .prefix(10)
            + highScores.filter { $0.gameName != score.gameName }
        
        saveScores()
    }
    
    /// Get the highest score for a specific game
    func getHighScore(for gameName: String) -> GameScore? {
        return highScores
            .filter { $0.gameName == gameName }
            .max(by: { $0.score < $1.score })
    }
    
    /// Get all scores for a specific game
    func getScores(for gameName: String) -> [GameScore] {
        return highScores
            .filter { $0.gameName == gameName }
            .sorted { $0.score > $1.score }
    }
    
    private func loadScores() {
        guard let data = userDefaults.data(forKey: scoresKey),
              let scores = try? JSONDecoder().decode([GameScore].self, from: data) else {
            highScores = []
            return
        }
        highScores = scores
    }
    
    private func saveScores() {
        guard let data = try? JSONEncoder().encode(highScores) else { return }
        userDefaults.set(data, forKey: scoresKey)
    }
} 