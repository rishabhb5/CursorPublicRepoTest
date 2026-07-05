// 20250608
// ActiveItemView - Card Style

import SwiftUI
import SwiftData

struct ActiveItemView: View {
    
    // MARK: - VARIABLES
    @Environment(\.modelContext) private var context
    let item: Item
    let showDragHandle: Bool
    
    init(item: Item, showDragHandle: Bool = true) {
        self.item = item
        self.showDragHandle = showDragHandle
    }
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(item.title)
                .foregroundColor(.appPrimaryText)
                .font(.custom("Avenir", size: 16))
                .lineLimit(6)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                
            
            Spacer()
            
            // DateBadgeDragHandle
            VStack(spacing: 8) {
                // Date badge
                Text(item.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.custom("Avenir", size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Color.purple.opacity(0.6)
                    )
                    .cornerRadius(6)
                
                // Conditionally show drag handle
                if showDragHandle {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(Color.purple.opacity(0.8))
                        .font(.system(size: 16))
                        .frame(width: 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            // Card gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appCardGradientTop,
                    Color.appCardGradientBottom
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            // Purple left border
            Rectangle()
                .fill(Color(red: 0.54, green: 0.17, blue: 0.89)) // #8a2be2
                .frame(width: 4)
                .cornerRadius(2),
            alignment: .leading
        )
        .cornerRadius(10) // Changed from 0 to 10 for rounded corners like Completed items
        .shadow(
            color: Color(red: 0.54, green: 0.17, blue: 0.89).opacity(0.3), // Purple shadow
            radius: 10,
            x: 0,
            y: 4
        )
        .contentShape(Rectangle())
        .listRowBackground(Color.clear) // Remove default row background
        .listRowSeparator(.visible) // Show separators
        .listSectionSeparator(.hidden) // Hide section separators if any
        .listRowSeparatorTint(Color.appListSeparator)
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: false) // For hover-like effects
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                toggleCompletion()
            } label: {
                Label(
                    "Complete",
                    systemImage: "checkmark.circle"
                )
            }
            .tint(.green)
        }
    }
    
    // MARK: - FUNCTIONS
    private func toggleCompletion() {
        withAnimation {
            item.isCompleted.toggle()
            item.completedAt = Date()
            try? context.save()
        }
    }
}

