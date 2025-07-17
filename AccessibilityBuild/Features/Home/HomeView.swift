import SwiftUI

/// Home screen view with app introduction and navigation to games
struct HomeView: View {
    @State private var isDarkMode = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Modern cool color palette
    private var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
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
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 40) {
                    // App Header
                    headerSection
                    
                    // Welcome Message
                    welcomeMessageSection
                    
                    // Main Action Button
                    mainActionButton
                    
                    // Footer Section
                    footerSection
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 28)
                .padding(.top, 30)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarHidden(true)
        .background(
            colorScheme == .dark ? Color.black : backgroundGradient
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Accessibility.build home screen")
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 24) {
            // Modern icon container
            ZStack {
                Circle()
                    .fill(primaryGradient)
                    .frame(width: 100, height: 100)
                    .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: "accessibility")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.white)
            }
            .accessibilityHidden(true) // Decorative icon
            
            // App Title with gradient text effect
            VStack(spacing: 8) {
                Text("Accessibility.build")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(primaryGradient)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel("Accessibility dot build app")
                
                // Subtle tagline
                Text("Learn • Play • Build")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.gray.opacity(0.7))
                    .tracking(2)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Welcome Message Section
    private var welcomeMessageSection: some View {
        VStack(spacing: 24) {
            // Modern card container
            VStack(spacing: 20) {
                Text("Accessibility tools are coming soon to iOS! For now, enjoy our free accessibility-themed games.")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.primary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel("Accessibility tools are coming soon to iOS! For now, enjoy our free accessibility-themed games.")
                
                // Subtitle for context
                Text("Learn about web accessibility while having fun with interactive mini-games designed to test your knowledge.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.secondary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
            )
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Main Action Button
    private var mainActionButton: some View {
        NavigationLink(destination: GamesView()) {
            HStack(spacing: 12) {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 18, weight: .medium))
                
                Text("Browse Games")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(primaryGradient)
                    .shadow(color: Color.blue.opacity(0.4), radius: 20, x: 0, y: 10)
            )
            .contentShape(Rectangle())
        }
        .accessibleButton(
            action: "Browse Games",
            hint: "Navigate to the games list to start playing accessibility-themed games"
        )
        .accessibleAnimation(.easeInOut(duration: AccessibilityHelpers.animationDuration), value: colorScheme)
        .scaleEffect(1.0)
        .onTapGesture {}
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in }
                .onEnded { _ in }
        )
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        VStack(spacing: 32) {
            // Subtle divider
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .frame(maxWidth: 60)
                .accessibilityHidden(true)
            
            VStack(spacing: 24) {
                // Learn More Link - Modern button style
                Button(action: openWebsite) {
                    HStack(spacing: 12) {
                        Image(systemName: "safari")
                            .font(.system(size: 16, weight: .medium))
                        Text("Learn more")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                    )
                }
                .accessibleButton(
                    action: "Learn more about Accessibility.build",
                    hint: "Opens the Accessibility.build website in Safari"
                )
                
                // Dark Mode Toggle - Minimalist style
                HStack {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text("Dark Mode")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDarkMode)
                        .toggleStyle(SwitchToggleStyle(tint: primaryGradient.stops.first?.color ?? .blue))
                }
                .padding(.horizontal, 4)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Dark mode toggle")
                .accessibilityHint("Switches between light and dark appearance")
                .onChange(of: isDarkMode) { _, newValue in
                    // Note: In a real app, you'd implement proper dark mode persistence
                    // For now, this is just a visual toggle
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    // MARK: - Actions
    private func openWebsite() {
        guard let url = URL(string: "https://accessibility.build") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Preview
#Preview("Light Mode") {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.dark)
}

#Preview("Large Text") {
    NavigationStack {
        HomeView()
    }
    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
} 