import SwiftUI

struct SummaryView: View {
    let count: Int
    let itemType: String
    let iconName: String

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            HStack(spacing: 2) {
                Image(systemName: iconName)
                    .foregroundColor(.purple)
                    .font(.system(size: 17))
                Text("\(count) \(itemType.capitalized) Item\(count == 1 ? "" : "s")")
                    .font(.custom("Avenir", size: 17))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(width: 160, alignment: .center)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6).opacity(0.8))
            )
        }
        .frame(width: 220, alignment: .center)
    }
}
