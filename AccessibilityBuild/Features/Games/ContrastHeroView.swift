import SwiftUI

/// Contrast Hero game - Test knowledge of WCAG color contrast requirements
struct ContrastHeroView: View {
    let scoreManager = GameScoreManager()
    
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var showingResult = false
    @State private var showingFinalScore = false
    @State private var selectedAnswer: Bool?
    @State private var questions: [ContrastQuestion] = []
    @Environment(\.colorScheme) private var colorScheme
    
    private let totalQuestions = 10
    
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
    
    private var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 28) {
                    if showingFinalScore {
                        FinalScoreView(
                            score: score,
                            totalQuestions: totalQuestions,
                            onPlayAgain: resetGame,
                            scoreManager: scoreManager
                        )
                    } else {
                        // Game Header
                        gameHeader
                        
                        // Current Question
                        if currentQuestion < questions.count {
                            QuestionView(
                                question: questions[currentQuestion],
                                selectedAnswer: $selectedAnswer,
                                showingResult: $showingResult,
                                onAnswerSelected: handleAnswerSelection
                            )
                        }
                        
                        // Action Button
                        actionButton
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationTitle("Contrast Hero")
        .navigationBarTitleDisplayMode(.large)
        .background(
            colorScheme == .dark ? Color.black : backgroundGradient
        )
        .onAppear(perform: setupGame)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Contrast Hero game")
    }
    
    // MARK: - Game Header
    private var gameHeader: some View {
        VStack(spacing: 16) {
            // Progress Indicator
            HStack {
                Text("Question \(currentQuestion + 1) of \(totalQuestions)")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.secondary.opacity(0.8))
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(primaryGradient)
                    
                    Text("Score: \(score)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(primaryGradient)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Question \(currentQuestion + 1) of \(totalQuestions). Current score: \(score)")
            
            // Modern Progress Bar
            VStack(spacing: 8) {
                ProgressView(value: Double(currentQuestion + 1), total: Double(totalQuestions))
                    .progressViewStyle(LinearProgressViewStyle(tint: primaryGradient.stops.first?.color ?? .blue))
                    .scaleEffect(y: 1.5)
                    .accessibilityLabel("Game progress")
                    .accessibilityValue("\(currentQuestion + 1) of \(totalQuestions) questions completed")
                
                Text("\(Int((Double(currentQuestion + 1) / Double(totalQuestions)) * 100))% Complete")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.secondary.opacity(0.7))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Group {
            if showingResult {
                Button("Next Question") {
                    nextQuestion()
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(primaryGradient)
                        .shadow(color: Color.blue.opacity(0.4), radius: 15, x: 0, y: 8)
                )
                .accessibleButton(
                    action: "Next Question",
                    hint: "Continue to the next contrast question"
                )
            } else if selectedAnswer != nil {
                Button("Submit Answer") {
                    checkAnswer()
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(primaryGradient)
                        .shadow(color: Color.blue.opacity(0.4), radius: 15, x: 0, y: 8)
                )
                .accessibleButton(
                    action: "Submit Answer",
                    hint: "Submit your answer for this question"
                )
            }
        }
        .accessibleAnimation(.easeInOut(duration: AccessibilityHelpers.animationDuration), value: showingResult)
    }
    
    // MARK: - Game Logic
    private func setupGame() {
        questions = ContrastQuestion.generateRandomQuestions(count: totalQuestions)
        currentQuestion = 0
        score = 0
        showingResult = false
        showingFinalScore = false
        selectedAnswer = nil
    }
    
    private func resetGame() {
        setupGame()
    }
    
    private func handleAnswerSelection(_ answer: Bool) {
        selectedAnswer = answer
    }
    
    private func checkAnswer() {
        guard let selectedAnswer = selectedAnswer else { return }
        
        let currentQuestionData = questions[currentQuestion]
        let isCorrect = selectedAnswer == currentQuestionData.correctAnswer
        
        if isCorrect {
            score += 1
        }
        
        withAnimation(.easeInOut(duration: AccessibilityHelpers.animationDuration)) {
            showingResult = true
        }
        
        // Announce result for VoiceOver users
        let announcement = isCorrect ? "Correct answer!" : "Incorrect answer"
        UIAccessibility.post(notification: .announcement, argument: announcement)
    }
    
    private func nextQuestion() {
        currentQuestion += 1
        selectedAnswer = nil
        
        if currentQuestion >= totalQuestions {
            // Game finished
            let gameScore = GameScore(
                gameName: "Contrast Hero",
                score: score,
                totalQuestions: totalQuestions,
                timestamp: Date()
            )
            scoreManager.saveScore(gameScore)
            
            withAnimation(.easeInOut(duration: AccessibilityHelpers.animationDuration)) {
                showingFinalScore = true
            }
            
            // Announce game completion
            UIAccessibility.post(notification: .announcement, argument: "Game completed! Final score: \(score) out of \(totalQuestions)")
        } else {
            withAnimation(.easeInOut(duration: AccessibilityHelpers.animationDuration)) {
                showingResult = false
            }
        }
    }
}

// MARK: - Question View Component
struct QuestionView: View {
    let question: ContrastQuestion
    @Binding var selectedAnswer: Bool?
    @Binding var showingResult: Bool
    let onAnswerSelected: (Bool) -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    private var cardGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white, Color.white.opacity(0.95)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        VStack(spacing: 28) {
            // Question Title
            Text("Does this pass WCAG AA contrast?")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .accessibilityAddTraits(.isHeader)
            
            // Color Contrast Sample
            ColorContrastSample(
                foregroundColor: question.foregroundColor,
                backgroundColor: question.backgroundColor,
                sampleText: question.sampleText
            )
            
            // Answer Options
            if !showingResult {
                AnswerButtons(
                    selectedAnswer: selectedAnswer,
                    onAnswerSelected: onAnswerSelected
                )
            } else {
                ResultDisplay(
                    userAnswer: selectedAnswer,
                    correctAnswer: question.correctAnswer,
                    explanation: question.explanation,
                    contrastRatio: question.contrastRatio
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : cardGradient)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
        )
    }
}

// MARK: - Color Contrast Sample Component
struct ColorContrastSample: View {
    let foregroundColor: Color
    let backgroundColor: Color
    let sampleText: String
    
    var body: some View {
        VStack(spacing: 20) {
            // Large sample
            VStack(spacing: 16) {
                Text("Large Text Sample")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.secondary.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(sampleText)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(foregroundColor)
                    .padding(28)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(backgroundColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Large text sample: \(sampleText)")
            .accessibilityHint("This shows how large text would appear with the given color combination")
            
            // Small sample for comparison
            VStack(spacing: 12) {
                Text("Normal Text Sample")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.secondary.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text("Smaller text example for comparison")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(foregroundColor)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(backgroundColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                    )
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Normal text example")
            .accessibilityHint("This shows how normal sized text would appear with the same colors")
        }
    }
}

// MARK: - Answer Buttons Component
struct AnswerButtons: View {
    let selectedAnswer: Bool?
    let onAnswerSelected: (Bool) -> Void
    
    private var yesGradient: LinearGradient {
        LinearGradient(
            colors: [Color.green, Color.green.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var noGradient: LinearGradient {
        LinearGradient(
            colors: [Color.red, Color.red.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // "Yes" Button
            Button {
                onAnswerSelected(true)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: selectedAnswer == true ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Yes, it passes")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    
                    Spacer()
                }
                .foregroundColor(selectedAnswer == true ? .white : Color.green)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(selectedAnswer == true ? yesGradient : Color.green.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.green.opacity(0.3), lineWidth: selectedAnswer == true ? 0 : 1)
                        )
                )
            }
            .accessibleButton(
                action: "Yes, this passes WCAG AA contrast",
                hint: "Select this if you think the color combination meets accessibility standards"
            )
            
            // "No" Button
            Button {
                onAnswerSelected(false)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: selectedAnswer == false ? "xmark.circle.fill" : "xmark.circle")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("No, it fails")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    
                    Spacer()
                }
                .foregroundColor(selectedAnswer == false ? .white : Color.red)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(selectedAnswer == false ? noGradient : Color.red.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.red.opacity(0.3), lineWidth: selectedAnswer == false ? 0 : 1)
                        )
                )
            }
            .accessibleButton(
                action: "No, this does not pass WCAG AA contrast",
                hint: "Select this if you think the color combination does not meet accessibility standards"
            )
        }
    }
}

// MARK: - Result Display Component
struct ResultDisplay: View {
    let userAnswer: Bool?
    let correctAnswer: Bool
    let explanation: String
    let contrastRatio: Double
    
    private var isCorrect: Bool {
        userAnswer == correctAnswer
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Result Status
            HStack(spacing: 12) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(isCorrect ? .green : .red)
                
                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(isCorrect ? .green : .red)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(isCorrect ? "Correct answer" : "Incorrect answer")
            
            // Contrast Ratio Information
            VStack(spacing: 8) {
                Text("Contrast Ratio: \(String(format: "%.1f", contrastRatio)):1")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text("WCAG AA requires 4.5:1 for normal text")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Contrast ratio is \(String(format: "%.1f", contrastRatio)) to 1. WCAG AA requires 4.5 to 1 for normal text.")
            
            // Explanation
            Text(explanation)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel("Explanation: \(explanation)")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        )
    }
}

// MARK: - Final Score View Component
struct FinalScoreView: View {
    let score: Int
    let totalQuestions: Int
    let onPlayAgain: () -> Void
    let scoreManager: GameScoreManager
    
    private var percentage: Int {
        Int((Double(score) / Double(totalQuestions)) * 100)
    }
    
    private var performanceMessage: String {
        switch percentage {
        case 90...100: return "Excellent! You're a contrast expert!"
        case 70..<90: return "Great job! You have a solid understanding of contrast."
        case 50..<70: return "Good effort! Keep practicing to improve."
        default: return "Keep learning! Contrast is tricky but important."
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Trophy/Score Display
            VStack(spacing: 16) {
                Image(systemName: percentage >= 70 ? "trophy.fill" : "medal.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(percentage >= 70 ? .yellow : .orange)
                    .accessibilityHidden(true)
                
                Text("Game Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                
                Text("\(score)/\(totalQuestions) (\(percentage)%)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
            
            // Performance Message
            Text(performanceMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            // High Score Information
            if let highScore = scoreManager.getHighScore(for: "Contrast Hero") {
                VStack(spacing: 8) {
                    Text("Your Best Score")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text(highScore.formattedScore)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Your best score is \(highScore.formattedScore)")
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                Button("Play Again") {
                    onPlayAgain()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                )
                .accessibleButton(
                    action: "Play Again",
                    hint: "Start a new game of Contrast Hero"
                )
                
                Button("Back to Games") {
                    // Navigation will handle this automatically
                }
                .font(.body)
                .foregroundStyle(.blue)
                .accessibleButton(
                    action: "Back to Games",
                    hint: "Return to the games list"
                )
            }
        }
        .padding(32)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Final score: \(score) out of \(totalQuestions). \(performanceMessage)")
    }
}

// MARK: - Question Data Model
struct ContrastQuestion {
    let foregroundColor: Color
    let backgroundColor: Color
    let sampleText: String
    let correctAnswer: Bool
    let explanation: String
    let contrastRatio: Double
    
    static func generateRandomQuestions(count: Int) -> [ContrastQuestion] {
        let colorPairs: [(Color, Color, String)] = [
            // Passing combinations
            (.black, .white, "This high contrast combination easily passes WCAG AA with a ratio above 15:1."),
            (.white, .black, "White text on black background provides excellent contrast for accessibility."),
            (.blue, .white, "Blue text on white background typically provides good contrast."),
            (.white, Color(.systemBlue), "White text on blue background usually meets WCAG AA requirements."),
            
            // Failing combinations
            (Color(.systemGray), .white, "Light gray on white has poor contrast and fails WCAG AA requirements."),
            (.yellow, .white, "Yellow text on white background has very poor contrast and is hard to read."),
            (Color(.systemGray2), Color(.systemGray6), "Similar gray tones provide insufficient contrast."),
            (.red, Color(.systemPink), "Red text on pink background lacks adequate contrast."),
            
            // Borderline cases
            (Color(.systemOrange), .white, "Orange text on white may or may not pass depending on the specific shade."),
            (.purple, .white, "Purple text contrast depends on the specific shade and lightness."),
        ]
        
        var questions: [ContrastQuestion] = []
        let sampleTexts = ["Sample Text", "Read Me", "Important", "Click Here", "Menu Item"]
        
        for i in 0..<count {
            let pairIndex = i % colorPairs.count
            let (foreground, background, explanation) = colorPairs[pairIndex]
            let sampleText = sampleTexts[i % sampleTexts.count]
            
            let contrastRatio = ContrastUtils.contrastRatio(foreground: foreground, background: background)
            let passesWCAG = ContrastUtils.passesWCAGAA(foreground: foreground, background: background)
            
            questions.append(ContrastQuestion(
                foregroundColor: foreground,
                backgroundColor: background,
                sampleText: sampleText,
                correctAnswer: passesWCAG,
                explanation: explanation,
                contrastRatio: contrastRatio
            ))
        }
        
        return questions.shuffled()
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ContrastHeroView()
    }
}

#Preview("Final Score") {
    NavigationStack {
        FinalScoreView(
            score: 8,
            totalQuestions: 10,
            onPlayAgain: {},
            scoreManager: GameScoreManager()
        )
    }
} 