import SwiftUI

/// Profile and settings view for user preferences and app information
struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("userName") private var userName = "Accessibility Learner"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("soundEffectsEnabled") private var soundEffectsEnabled = true
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = true
    @State private var showingAbout = false
    @State private var showingHelp = false
    
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
                // Profile Header
                profileHeader
                
                // Accessibility Settings
                accessibilitySection
                
                // App Preferences
                preferencesSection
                
                // Support & Info
                supportSection
                
                // About Section
                aboutSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .background(
            colorScheme == .dark ? Color.black : backgroundGradient
        )
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("User profile and settings")
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 20) {
            // Avatar
            ZStack {
                Circle()
                    .fill(primaryGradient)
                    .frame(width: 100, height: 100)
                    .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Text(String(userName.prefix(1)).uppercased())
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .accessibilityHidden(true)
            
            // User Info
            VStack(spacing: 8) {
                Text(userName)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Accessibility Enthusiast")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                
                // Quick Stats
                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("3")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(primaryGradient)
                        Text("Games")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("7")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(primaryGradient)
                        Text("Days")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("85%")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(primaryGradient)
                        Text("Accuracy")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Accessibility Section
    private var accessibilitySection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "Accessibility Settings", icon: "accessibility")
            
            VStack(spacing: 16) {
                AccessibilityInfoCard(
                    title: "VoiceOver",
                    description: UIAccessibility.isVoiceOverRunning ? "Active" : "Inactive",
                    icon: "speaker.wave.3.fill",
                    isActive: UIAccessibility.isVoiceOverRunning
                )
                
                AccessibilityInfoCard(
                    title: "Reduce Motion",
                    description: UIAccessibility.isReduceMotionEnabled ? "Enabled" : "Disabled",
                    icon: "move.3d",
                    isActive: UIAccessibility.isReduceMotionEnabled
                )
                
                AccessibilityInfoCard(
                    title: "Dynamic Type",
                    description: getCurrentTextSize(),
                    icon: "textformat.size",
                    isActive: true
                )
                
                AccessibilityInfoCard(
                    title: "High Contrast",
                    description: UIAccessibility.isDarkerSystemColorsEnabled ? "Enabled" : "Disabled",
                    icon: "circle.lefthalf.filled",
                    isActive: UIAccessibility.isDarkerSystemColorsEnabled
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
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "App Preferences", icon: "gearshape.fill")
            
            VStack(spacing: 16) {
                ToggleRow(
                    title: "Notifications",
                    description: "Get reminded to practice daily",
                    icon: "bell.fill",
                    isOn: $notificationsEnabled
                )
                
                ToggleRow(
                    title: "Sound Effects",
                    description: "Play audio feedback during games",
                    icon: "speaker.wave.2.fill",
                    isOn: $soundEffectsEnabled
                )
                
                ToggleRow(
                    title: "Haptic Feedback",
                    description: "Feel vibrations for interactions",
                    icon: "iphone.radiowaves.left.and.right",
                    isOn: $hapticFeedbackEnabled
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
    
    // MARK: - Support Section
    private var supportSection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "Support & Information", icon: "questionmark.circle.fill")
            
            VStack(spacing: 12) {
                ActionRow(
                    title: "Help & FAQ",
                    description: "Get answers to common questions",
                    icon: "questionmark.circle",
                    action: { showingHelp = true }
                )
                
                ActionRow(
                    title: "Contact Support",
                    description: "Reach out for assistance",
                    icon: "envelope",
                    action: { sendSupportEmail() }
                )
                
                ActionRow(
                    title: "Rate This App",
                    description: "Help us improve with your feedback",
                    icon: "star",
                    action: { rateApp() }
                )
                
                ActionRow(
                    title: "Share App",
                    description: "Tell others about accessibility.build",
                    icon: "square.and.arrow.up",
                    action: { shareApp() }
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
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "About", icon: "info.circle.fill")
            
            VStack(spacing: 12) {
                ActionRow(
                    title: "About This App",
                    description: "Learn more about our mission",
                    icon: "accessibility",
                    action: { showingAbout = true }
                )
                
                ActionRow(
                    title: "Privacy Policy",
                    description: "How we protect your data",
                    icon: "lock.shield",
                    action: { openPrivacyPolicy() }
                )
                
                ActionRow(
                    title: "Terms of Service",
                    description: "App usage terms and conditions",
                    icon: "doc.text",
                    action: { openTermsOfService() }
                )
            }
            
            // Version Info
            VStack(spacing: 8) {
                Text("Version 1.0.0")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                
                Text("Made with ♿ for everyone")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(.tertiary)
            }
            .padding(.top, 16)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Helper Functions
    private func getCurrentTextSize() -> String {
        let category = UIApplication.shared.preferredContentSizeCategory
        switch category {
        case .extraSmall: return "Extra Small"
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        case .extraLarge: return "Extra Large"
        case .extraExtraLarge: return "Extra Extra Large"
        case .extraExtraExtraLarge: return "Extra Extra Extra Large"
        case .accessibilityMedium: return "Accessibility Medium"
        case .accessibilityLarge: return "Accessibility Large"
        case .accessibilityExtraLarge: return "Accessibility Extra Large"
        case .accessibilityExtraExtraLarge: return "Accessibility Extra Extra Large"
        case .accessibilityExtraExtraExtraLarge: return "Accessibility Extra Extra Extra Large"
        default: return "Large"
        }
    }
    
    private func sendSupportEmail() {
        let email = "support@accessibility.build"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        // In a real app, this would open the App Store rating
        print("Rate app functionality")
    }
    
    private func shareApp() {
        let text = "Check out Accessibility.build - Learn web accessibility through fun games!"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(av, animated: true)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://accessibility.build/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfService() {
        if let url = URL(string: "https://accessibility.build/terms") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Supporting Components
struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.blue)
            
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .accessibilityAddTraits(.isHeader)
            
            Spacer()
        }
    }
}

struct AccessibilityInfoCard: View {
    let title: String
    let description: String
    let icon: String
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(isActive ? .green : .secondary)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Circle()
                .fill(isActive ? .green : .gray)
                .frame(width: 8, height: 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description)")
    }
}

struct ToggleRow: View {
    let title: String
    let description: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description). \(isOn ? "Enabled" : "Disabled")")
    }
}

struct ActionRow: View {
    let title: String
    let description: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text(description)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
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

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "accessibility")
                            .font(.system(size: 60, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    // About Content
                    VStack(spacing: 20) {
                        Text("Accessibility.build")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                        
                        Text("Making the web accessible for everyone through education, games, and tools.")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        
                        Text("""
                        Our mission is to make web accessibility knowledge accessible to everyone. Through interactive games and comprehensive learning resources, we help developers, designers, and content creators build inclusive digital experiences.
                        
                        Every feature in this app is designed with accessibility in mind, serving as both a learning tool and a demonstration of inclusive design principles.
                        """)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .lineSpacing(4)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 32)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Help View
struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let faqItems = [
        FAQItem(question: "How do I play Contrast Hero?", answer: "Look at the color combination shown and decide if it meets WCAG AA contrast requirements (4.5:1 ratio). Tap 'Yes' if it passes or 'No' if it doesn't."),
        FAQItem(question: "What is WCAG?", answer: "WCAG (Web Content Accessibility Guidelines) are international standards for making web content accessible to people with disabilities."),
        FAQItem(question: "How are scores calculated?", answer: "Your score is based on correct answers out of total questions. Scores are saved locally on your device."),
        FAQItem(question: "Can I use this app with VoiceOver?", answer: "Yes! This app is fully compatible with VoiceOver and other assistive technologies."),
        FAQItem(question: "How do I reset my progress?", answer: "Currently, progress resets when you delete and reinstall the app. A reset option will be added in future updates.")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(faqItems) { item in
                        FAQCard(item: item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Help & FAQ")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQCard: View {
    let item: FAQItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(item.question)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            
            if isExpanded {
                Text(item.answer)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
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
        .accessibilityLabel("\(item.question). \(isExpanded ? item.answer : "Tap to expand")")
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
} 