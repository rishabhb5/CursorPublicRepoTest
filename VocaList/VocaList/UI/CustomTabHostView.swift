import SwiftUI

// Host view for custom pill-shaped, hovering tab bar
struct CustomTabHostView: View {
    enum Tab: CaseIterable {
        case active, completed, settings
    }
    
    @State private var selectedTab: Tab = .active
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    Group {
                        switch selectedTab {
                        case .active:
                            ActiveView()
                                .transition(tabTransition(for: .active))
                        case .completed:
                            CompletedView()
                                .transition(tabTransition(for: .completed))
                        case .settings:
                            SettingsView()
                                .transition(tabTransition(for: .settings))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0), value: selectedTab)
                }

                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        tabButton(title: "Active", icon: "bolt.fill", tab: .active, color: .purple)
                        tabButton(title: "Completed", icon: "checkmark.circle.fill", tab: .completed, color: .green)
                        tabButton(title: "Settings", icon: "gearshape.fill", tab: .settings, color: .gray)
                    }
                    .background(
                        Capsule()
                            .fill(Color(.darkGray).opacity(0.93))
                            .shadow(color: Color.purple.opacity(0.25), radius: 8, y: 2)
                    )
                    .padding(.horizontal, 28)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .zIndex(2)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 0)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func tabTransition(for tab: Tab) -> AnyTransition {
        switch tab {
        case .active:
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .completed, .settings:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        }
    }

    // MARK: - Tab Button
    @ViewBuilder
    private func tabButton(title: String, icon: String, tab: Tab, color: Color) -> some View {
        Button(action: { 
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedTab = tab 
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
            .foregroundColor(selectedTab == tab ? color : .gray)
            .background(
                Capsule()
                    .fill(selectedTab == tab ? Color.purple.opacity(0.18) : Color.clear)
                    .shadow(color: selectedTab == tab ? Color.purple.opacity(0.09) : .clear, radius: 3)
            )
            .scaleEffect(selectedTab == tab ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
