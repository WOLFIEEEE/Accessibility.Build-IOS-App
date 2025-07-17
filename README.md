# Accessibility.build iOS App (MVP)

A fully accessible iOS app focusing on accessibility-themed games, built with SwiftUI following modern iOS development best practices.

## 🎯 Overview

**Accessibility.build** is an iOS app designed to teach web accessibility principles through interactive games. This MVP version contains one fully functional game with plans for additional accessibility tools in future releases.

## 🎮 Features

### Current Features
- **Home Screen**: Welcome message and navigation to games
- **Games List**: Browse available accessibility-themed games  
- **Contrast Hero Game**: Test knowledge of WCAG color contrast requirements
- **Score Tracking**: Local high score persistence using UserDefaults
- **Full Accessibility Support**: VoiceOver, Dynamic Type, reduced motion, dark mode

### Coming Soon
- Alt Text Detective game
- Focus Flow keyboard navigation game
- Accessibility tools (contrast checker, alt text generator)
- AI-powered accessibility insights

## 📱 Technical Specifications

- **Platform**: iOS 16.0+
- **Language**: Swift (latest)
- **Framework**: SwiftUI with MVVM architecture
- **Storage**: UserDefaults for local score persistence
- **Accessibility**: Fully compliant with iOS accessibility guidelines

## 🏗️ Architecture

```
Accessibility.Build-IOS-App/
├── App.swift                          # App entry point
├── Views/
│   ├── HomeView.swift                 # Welcome screen
│   ├── GamesView.swift                # Games list
│   └── ContrastHeroView.swift         # Contrast quiz game
├── Models/
│   └── GameScore.swift                # Score persistence model
├── Utilities/
│   └── AccessibilityHelpers.swift     # Accessibility utilities
├── Info.plist                         # App configuration
└── Package.swift                      # Swift Package Manager
```

## 🚀 Getting Started

### Requirements
- Xcode 15.0+
- iOS 16.0+ Simulator or Device
- macOS 14.0+ (for development)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd Accessibility.Build-IOS-App
   ```

2. **Open in Xcode**:
   ```bash
   open Package.swift
   ```
   
   Or drag the folder into Xcode.

3. **Build and Run**:
   - Select your target device/simulator
   - Press `Cmd+R` or click the Run button
   - The app will launch showing the home screen

### Alternative: Swift Package Manager
```bash
swift build
swift run # (Note: This builds but won't launch iOS simulator)
```

## ♿ Accessibility Features

This app demonstrates best practices for iOS accessibility:

### VoiceOver Support
- All UI elements have proper accessibility labels
- Logical reading order and navigation
- Contextual hints for interactive elements
- Announcements for game state changes

### Visual Accessibility
- Support for Dynamic Type (text scaling)
- High contrast mode compatibility
- Dark mode support
- Reduced motion preferences respected

### Motor Accessibility
- Large touch targets (minimum 44pt)
- Easy navigation with assistive technologies
- Keyboard navigation support where applicable

## 🎮 Game: Contrast Hero

Test your knowledge of WCAG color contrast requirements:

- **Objective**: Identify if color combinations pass WCAG AA standards
- **Questions**: 10 randomized color contrast scenarios
- **Scoring**: Track your progress and high scores
- **Learning**: Detailed explanations for each answer
- **Accessibility**: Fully accessible with screen readers

### Gameplay
1. View a color combination sample
2. Decide if it passes WCAG AA contrast (4.5:1 ratio)
3. Select "Yes" or "No"
4. Learn from detailed explanations
5. Track your improvement over time

## 🧑‍💻 Development

### Code Style
- Follow SwiftUI best practices
- Use `@Observable` for view models (iOS 17+ pattern)
- Comprehensive accessibility modifiers
- Modular, reusable components
- Clear documentation and comments

### Adding New Games
1. Create a new view in `Views/`
2. Add the game to `availableGames` array in `GamesView.swift`
3. Implement proper accessibility modifiers
4. Add score tracking if applicable

### Testing Accessibility
- Enable VoiceOver: Settings > Accessibility > VoiceOver
- Test Dynamic Type: Settings > Display & Brightness > Text Size
- Test Dark Mode: Settings > Display & Brightness > Dark
- Test Reduced Motion: Settings > Accessibility > Motion > Reduce Motion

## 🗺️ Roadmap

### Phase 2: Additional Games
- **Alt Text Detective**: Identify missing/poor image descriptions
- **Focus Flow**: Keyboard navigation and focus management
- **Color Blindness Challenge**: Test color accessibility awareness

### Phase 3: Accessibility Tools
- **Contrast Checker**: Real-time color contrast analysis
- **Alt Text Generator**: AI-powered image description
- **Accessibility Scanner**: Analyze content for issues

### Phase 4: Advanced Features
- **User Accounts**: Cloud score syncing
- **Social Features**: Share achievements, compete with friends
- **Learning Modules**: Comprehensive accessibility education
- **Professional Tools**: Advanced accessibility testing suite

## 🤝 Contributing

We welcome contributions! This app serves as both an educational tool and a reference implementation for accessible iOS development.

### Guidelines
- Maintain accessibility compliance in all changes
- Follow existing code patterns and architecture
- Add comprehensive accessibility labels and hints
- Test with VoiceOver and other assistive technologies
- Document accessibility considerations in pull requests

## 📄 License

See LICENSE file for details.

## 🔗 Related

- [Accessibility.build Website](https://accessibility.build)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [iOS Accessibility Documentation](https://developer.apple.com/accessibility/ios/)

---

**Note**: This is an MVP focusing on games. Full accessibility tools and AI features will be added in future releases. The current implementation demonstrates best practices for accessible iOS app development using SwiftUI.