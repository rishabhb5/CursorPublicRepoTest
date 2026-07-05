import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        SettingsViewControllerRepresentable(modelContext: modelContext)
            .ignoresSafeArea()
    }
}

private struct SettingsViewControllerRepresentable: UIViewControllerRepresentable {
    let modelContext: ModelContext

    func makeUIViewController(context: Context) -> SettingsViewController {
        SettingsViewController(modelContext: modelContext)
    }

    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {}
}
