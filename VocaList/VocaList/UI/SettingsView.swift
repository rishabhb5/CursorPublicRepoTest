import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        SettingsTableViewController(modelContext: modelContext)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .ignoresSafeArea()
    }
}

private struct SettingsTableViewController: UIViewControllerRepresentable {
    let modelContext: ModelContext

    func makeUIViewController(context: Context) -> SettingsViewController {
        SettingsViewController(modelContext: modelContext)
    }

    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {}
}
