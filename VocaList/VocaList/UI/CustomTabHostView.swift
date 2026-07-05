import SwiftUI

// Host view for custom pill-shaped, hovering tab bar
struct CustomTabHostView: View {
    enum Tab {
        case active, completed
    }
    
    @State private var selectedTab: Tab = .active
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    Group {
                        if selectedTab == .active {
                            ActiveView()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        } else {
                            CompletedView()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0), value: selectedTab)
                    .padding(.top, 0)
                    Spacer()
                }

                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        tabButton(title: "Active", icon: "bolt.fill", tab: .active, color: .purple)
                        tabButton(title: "Completed", icon: "checkmark.circle.fill", tab: .completed, color: .green)
                    }
                    .background(
                        Capsule()
                            .fill(Color(.darkGray).opacity(0.93))
                            .shadow(color: Color.purple.opacity(0.25), radius: 8, y: 2)
                    )
                    .padding(.horizontal, 60)
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
            .padding(.horizontal, 20)
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
    }
}
