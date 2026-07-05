import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @AppStorage(SettingsKeys.appearanceMode) private var appearanceModeRaw = AppearanceMode.dark.rawValue

    @Query(filter: #Predicate<Item> { $0.isCompleted == true })
    private var completedItems: [Item]

    @State private var showClearConfirmation = false
    @State private var showClearSuccess = false

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: Binding(
                        get: { appearanceMode },
                        set: { appearanceModeRaw = $0.rawValue }
                    )) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.appListRowBackground)
                }

                Section("Data") {
                    Button(role: .destructive) {
                        showClearConfirmation = true
                    } label: {
                        HStack {
                            Text("Clear Completed Items")
                            Spacer()
                            Text(completedItemsCountLabel)
                                .foregroundColor(.secondary)
                        }
                    }
                    .disabled(completedItems.isEmpty)
                    .listRowBackground(Color.appListRowBackground)
                }

                Section("About") {
                    LabeledContent("Version", value: appVersion)
                        .listRowBackground(Color.appListRowBackground)

                    Text("Transcription runs entirely on-device. Your voice recordings and tasks are stored locally on this device.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .listRowBackground(Color.appListRowBackground)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Clear Completed Items?", isPresented: $showClearConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Clear All", role: .destructive) {
                    clearAllCompletedItems()
                }
            } message: {
                Text("This will permanently delete \(completedItems.count) completed item\(completedItems.count == 1 ? "" : "s").")
            }
            .alert("Completed Items Cleared", isPresented: $showClearSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("All completed items have been removed.")
            }
        }
    }

    private var completedItemsCountLabel: String {
        let count = completedItems.count
        return count == 1 ? "1 item" : "\(count) items"
    }

    private func clearAllCompletedItems() {
        let itemsToDelete = completedItems
        guard !itemsToDelete.isEmpty else { return }

        withAnimation {
            for item in itemsToDelete {
                context.delete(item)
            }

            do {
                try context.save()
                showClearSuccess = true
            } catch {
                print("Failed to clear completed items: \(error)")
            }
        }
    }
}
