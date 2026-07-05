import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            SettingsTableViewController(modelContext: modelContext)
                .padding(.top, -40)
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
