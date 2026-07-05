// 20250608
// CompletedItemView

import SwiftUI
import SwiftData

struct CompletedItemView: View {

    // MARK: - Variables
    @Environment(\.modelContext) private var context
    let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundColor(.gray)
                .font(.custom("Avenir", size: 16))
                .lineLimit(6)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)

            Spacer()

            VStack(spacing: 8) {
                // Created badge with purple background like ActiveItemView
                Text(item.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.custom("Avenir", size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.6))
                    .cornerRadius(6)
                // Completed badge remains green
                if let completedAt = item.completedAt as Date? {
                    Text(completedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.custom("Avenir", size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.7))
                        .cornerRadius(6)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.12, green: 0.12, blue: 0.12),
                    Color(red: 0.29, green: 0.17, blue: 0.35)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            Rectangle()
                .fill(Color.purple)
                .frame(width: 4)
                .cornerRadius(2),
            alignment: .leading
        )
        .cornerRadius(10)
        .shadow(
            color: Color.purple.opacity(0.3),
            radius: 10,
            x: 0,
            y: 4
        )
        .contentShape(Rectangle())
        .listRowBackground(Color.clear)
        .listRowSeparator(.visible)
        .listSectionSeparator(.hidden)
        .listRowSeparatorTint(Color.black)
        .scaleEffect(1.0)
    } /* body View*/
} /* CompletedItemView */


