import SwiftUI
import UIKit

/// Helper utilities for accessibility features
struct AccessibilityHelpers {
    
    /// Check if reduced motion is enabled
    static var isReducedMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
    
    /// Check if VoiceOver is running
    static var isVoiceOverRunning: Bool {
        UIAccessibility.isVoiceOverRunning
    }
    
    /// Check if the user prefers large text sizes
    static var isLargeTextEnabled: Bool {
        UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory
    }
    
    /// Get appropriate animation duration based on accessibility settings
    static var animationDuration: Double {
        isReducedMotionEnabled ? 0.0 : 0.3
    }
}

/// Custom view modifier for consistent accessibility styling
struct AccessibleButtonStyle: ViewModifier {
    let action: String
    let hint: String?
    
    func body(content: Content) -> some View {
        content
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(action)
            .accessibilityHint(hint ?? "")
            .accessibilityAction {
                // Default accessibility action
            }
    }
}

/// Custom view modifier for game elements
struct GameElementModifier: ViewModifier {
    let label: String
    let value: String?
    let hint: String?
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityValue(value ?? "")
            .accessibilityHint(hint ?? "")
    }
}

/// Extension for easier accessibility modifier application
extension View {
    /// Apply accessible button styling
    func accessibleButton(action: String, hint: String? = nil) -> some View {
        self.modifier(AccessibleButtonStyle(action: action, hint: hint))
    }
    
    /// Apply game element accessibility
    func gameElement(label: String, value: String? = nil, hint: String? = nil) -> some View {
        self.modifier(GameElementModifier(label: label, value: value, hint: hint))
    }
    
    /// Apply reduced motion animations
    func accessibleAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        if AccessibilityHelpers.isReducedMotionEnabled {
            return self.animation(nil, value: value)
        } else {
            return self.animation(animation, value: value)
        }
    }
}

/// Color contrast utilities for games
struct ContrastUtils {
    
    /// Calculate luminance for a color
    static func luminance(for color: Color) -> Double {
        // Convert SwiftUI Color to UIColor for component extraction
        let uiColor = UIColor(color)
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Apply gamma correction
        let adjustedRed = red <= 0.03928 ? red / 12.92 : pow((red + 0.055) / 1.055, 2.4)
        let adjustedGreen = green <= 0.03928 ? green / 12.92 : pow((green + 0.055) / 1.055, 2.4)
        let adjustedBlue = blue <= 0.03928 ? blue / 12.92 : pow((blue + 0.055) / 1.055, 2.4)
        
        // Calculate relative luminance
        return 0.2126 * adjustedRed + 0.7152 * adjustedGreen + 0.0722 * adjustedBlue
    }
    
    /// Calculate contrast ratio between two colors
    static func contrastRatio(foreground: Color, background: Color) -> Double {
        let foregroundLuminance = luminance(for: foreground)
        let backgroundLuminance = luminance(for: background)
        
        let lighter = max(foregroundLuminance, backgroundLuminance)
        let darker = min(foregroundLuminance, backgroundLuminance)
        
        return (lighter + 0.05) / (darker + 0.05)
    }
    
    /// Check if color combination passes WCAG AA (4.5:1 for normal text)
    static func passesWCAGAA(foreground: Color, background: Color) -> Bool {
        contrastRatio(foreground: foreground, background: background) >= 4.5
    }
    
    /// Check if color combination passes WCAG AAA (7:1 for normal text)
    static func passesWCAGAAA(foreground: Color, background: Color) -> Bool {
        contrastRatio(foreground: foreground, background: background) >= 7.0
    }
} 