import SwiftUI

/// Learning section with educational content about accessibility
struct LearnView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedCategory = 0
    
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
    
    private let categories = ["Basics", "Colors", "Navigation", "Content", "Testing"]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Header
                headerSection
                
                // Category Picker
                categoryPicker
                
                // Content based on selected category
                contentSection
                
                // Quick Tips
                quickTipsSection
                
                // Resources
                resourcesSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.large)
        .background(
            colorScheme == .dark ? Color.black : backgroundGradient
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Accessibility learning content")
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Accessibility Fundamentals")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(primaryGradient)
                .accessibilityAddTraits(.isHeader)
            
            Text("Master the principles of inclusive design with comprehensive guides and interactive examples.")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.secondary.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Category Picker
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Button(categories[index]) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = index
                        }
                    }
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(selectedCategory == index ? .white : .primary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedCategory == index ? primaryGradient : Color(.systemGray6))
                    )
                    .accessibleButton(
                        action: "Select \(categories[index]) category",
                        hint: "Learn about \(categories[index].lowercased()) accessibility concepts"
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 20) {
            switch selectedCategory {
            case 0: basicsContent
            case 1: colorsContent
            case 2: navigationContent
            case 3: contentContent
            case 4: testingContent
            default: basicsContent
            }
        }
    }
    
    // MARK: - Content by Category
    private var basicsContent: some View {
        VStack(spacing: 16) {
            LearnCard(
                title: "What is Web Accessibility?",
                description: "Learn the fundamentals of making digital content accessible to all users, including those with disabilities.",
                icon: "accessibility",
                color: .blue,
                content: """
                Web accessibility ensures that websites, tools, and technologies are designed so that people with disabilities can use them effectively.
                
                Key Principles (POUR):
                • Perceivable - Information must be presentable in ways users can perceive
                • Operable - Interface components must be operable
                • Understandable - Information and UI operation must be understandable
                • Robust - Content must be robust enough for various assistive technologies
                """
            )
            
            LearnCard(
                title: "WCAG Guidelines",
                description: "Understand the Web Content Accessibility Guidelines that define accessibility standards.",
                icon: "book.fill",
                color: .green,
                content: """
                WCAG 2.1 provides three levels of conformance:
                
                Level A (Minimum):
                • Basic accessibility features
                • Essential for any public website
                
                Level AA (Standard):
                • Recommended for most websites
                • Required by many laws and policies
                
                Level AAA (Enhanced):
                • Highest level of accessibility
                • Not required for entire websites
                """
            )
        }
    }
    
    private var colorsContent: some View {
        VStack(spacing: 16) {
            LearnCard(
                title: "Color Contrast",
                description: "Understand how color contrast affects readability and accessibility compliance.",
                icon: "eye.fill",
                color: .orange,
                content: """
                Color contrast is crucial for readability:
                
                WCAG AA Requirements:
                • Normal text: 4.5:1 contrast ratio
                • Large text (18pt+): 3:1 contrast ratio
                
                WCAG AAA Requirements:
                • Normal text: 7:1 contrast ratio
                • Large text: 4.5:1 contrast ratio
                
                Test your colors using our Contrast Hero game!
                """
            )
            
            LearnCard(
                title: "Color-Blind Accessibility",
                description: "Design for users with color vision deficiencies.",
                icon: "paintpalette.fill",
                color: .purple,
                content: """
                Don't rely on color alone to convey information:
                
                Best Practices:
                • Use icons, patterns, or text labels
                • Ensure sufficient contrast
                • Test with color blindness simulators
                
                Common Color Vision Types:
                • Deuteranomaly (green-weak)
                • Protanomaly (red-weak)  
                • Tritanomaly (blue-weak)
                • Complete color blindness (rare)
                """
            )
        }
    }
    
    private var navigationContent: some View {
        VStack(spacing: 16) {
            LearnCard(
                title: "Keyboard Navigation",
                description: "Ensure your interface works with keyboard-only navigation.",
                icon: "keyboard.fill",
                color: .blue,
                content: """
                Essential for users who can't use a mouse:
                
                Key Requirements:
                • All interactive elements must be keyboard accessible
                • Logical tab order
                • Visible focus indicators
                • Skip links for main content
                
                Common Keyboard Shortcuts:
                • Tab: Move forward
                • Shift+Tab: Move backward
                • Enter/Space: Activate
                • Escape: Cancel/close
                """
            )
            
            LearnCard(
                title: "Focus Management",
                description: "Properly manage focus for dynamic content and interactions.",
                icon: "target",
                color: .red,
                content: """
                Focus management is critical for screen readers:
                
                Best Practices:
                • Set focus to new content after navigation
                • Return focus after closing modals
                • Use proper heading hierarchy
                • Implement landmark regions
                
                ARIA Landmarks:
                • banner, navigation, main
                • complementary, contentinfo
                • search, form, region
                """
            )
        }
    }
    
    private var contentContent: some View {
        VStack(spacing: 16) {
            LearnCard(
                title: "Alternative Text",
                description: "Write effective alt text for images and visual content.",
                icon: "photo.fill",
                color: .green,
                content: """
                Alt text helps screen readers describe images:
                
                Guidelines:
                • Be concise but descriptive
                • Convey the purpose/function
                • Don't start with "image of" or "picture of"
                • Empty alt="" for decorative images
                
                Examples:
                Good: "Red stop sign at intersection"
                Bad: "Image of a sign"
                Decorative: alt=""
                """
            )
            
            LearnCard(
                title: "Headings Structure",
                description: "Create logical heading hierarchies for screen readers.",
                icon: "text.format",
                color: .indigo,
                content: """
                Proper heading structure aids navigation:
                
                Rules:
                • Only one H1 per page
                • Don't skip heading levels
                • Use headings for structure, not styling
                • Make headings descriptive
                
                Example Structure:
                H1: Page Title
                ├─ H2: Main Section
                │  ├─ H3: Subsection
                │  └─ H3: Another Subsection
                └─ H2: Another Main Section
                """
            )
        }
    }
    
    private var testingContent: some View {
        VStack(spacing: 16) {
            LearnCard(
                title: "Testing with Screen Readers",
                description: "Learn how to test your interfaces with assistive technologies.",
                icon: "speaker.wave.3.fill",
                color: .pink,
                content: """
                Test with real assistive technologies:
                
                Popular Screen Readers:
                • VoiceOver (macOS/iOS) - Built-in
                • NVDA (Windows) - Free
                • JAWS (Windows) - Commercial
                • TalkBack (Android) - Built-in
                
                Testing Checklist:
                • Navigate using only keyboard
                • Listen to content flow
                • Test form interactions
                • Verify landmark navigation
                """
            )
            
            LearnCard(
                title: "Automated Testing Tools",
                description: "Use tools to catch accessibility issues early in development.",
                icon: "wrench.and.screwdriver.fill",
                color: .teal,
                content: """
                Helpful testing tools and browser extensions:
                
                Browser Extensions:
                • axe DevTools
                • WAVE Web Accessibility Evaluator
                • Lighthouse (built into Chrome)
                • Colour Contrast Analyser
                
                Remember:
                Automated tools catch ~30% of issues.
                Manual testing is still essential!
                """
            )
        }
    }
    
    // MARK: - Quick Tips Section
    private var quickTipsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Quick Tips")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                QuickTip(
                    icon: "lightbulb.fill",
                    text: "Use semantic HTML elements like <button>, <nav>, and <main> for better accessibility.",
                    color: .yellow
                )
                
                QuickTip(
                    icon: "exclamationmark.triangle.fill",
                    text: "Never use color alone to convey important information.",
                    color: .red
                )
                
                QuickTip(
                    icon: "checkmark.circle.fill",
                    text: "Test your website with keyboard navigation and screen readers.",
                    color: .green
                )
                
                QuickTip(
                    icon: "text.alignleft",
                    text: "Write clear, descriptive link text instead of 'click here' or 'read more'.",
                    color: .blue
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
    
    // MARK: - Resources Section
    private var resourcesSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("External Resources")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                ResourceLink(
                    title: "WCAG 2.1 Guidelines",
                    description: "Official W3C accessibility guidelines",
                    url: "https://www.w3.org/WAI/WCAG21/quickref/"
                )
                
                ResourceLink(
                    title: "WebAIM",
                    description: "Comprehensive accessibility resources and training",
                    url: "https://webaim.org/"
                )
                
                ResourceLink(
                    title: "A11y Project",
                    description: "Community-driven accessibility checklist",
                    url: "https://www.a11yproject.com/"
                )
                
                ResourceLink(
                    title: "MDN Accessibility",
                    description: "Mozilla's accessibility documentation",
                    url: "https://developer.mozilla.org/en-US/docs/Web/Accessibility"
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
}

// MARK: - Supporting Components
struct LearnCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let content: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(color)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(description)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .accessibleButton(
                    action: isExpanded ? "Collapse content" : "Expand content",
                    hint: "Toggle detailed information"
                )
            }
            
            // Expanded Content
            if isExpanded {
                Text(content)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(description). \(isExpanded ? "Expanded" : "Collapsed")")
    }
}

struct QuickTip: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(color)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(.primary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Tip: \(text)")
    }
}

struct ResourceLink: View {
    let title: String
    let description: String
    let url: String
    
    var body: some View {
        Button {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text(description)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .accessibleButton(
            action: "Open \(title)",
            hint: "Opens \(description) in your web browser"
        )
    }
}

#Preview {
    NavigationStack {
        LearnView()
    }
} 