import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                List {
                    AppHeaderView()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.appListRowBackground)
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, -40)

                SettingsTableViewController(modelContext: modelContext)
            }
        }
    }
}

private struct SettingsTableViewController: UIViewControllerRepresentable {
    let modelContext: ModelContext

    func makeUIViewController(context: Context) -> SettingsViewController {
        SettingsViewController(modelContext: modelContext)
    }

    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {}
}
