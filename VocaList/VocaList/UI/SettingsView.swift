import SwiftUI
import SwiftData

struct SettingsView: UIViewControllerRepresentable {
    @Environment(\.modelContext) private var modelContext

    func makeUIViewController(context: Context) -> SettingsViewController {
        SettingsViewController(modelContext: modelContext)
    }

    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {}
}
