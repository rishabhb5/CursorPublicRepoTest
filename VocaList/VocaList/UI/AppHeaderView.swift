import SwiftUI

struct AppHeaderView<TrailingContent: View>: View {
    let trailingContent: TrailingContent

    init(@ViewBuilder trailingContent: () -> TrailingContent) {
        self.trailingContent = trailingContent()
    }

    var body: some View {
        HStack(alignment: .center) {
            Text("VocaList")
                .font(.custom("Avenir", size: 32))
                .foregroundColor(.purple)

            Spacer()

            trailingContent
        }
    }
}

extension AppHeaderView where TrailingContent == EmptyView {
    init() {
        self.trailingContent = EmptyView()
    }
}
