import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context

    @AppStorage(SettingsKeys.appearanceMode) private var appearanceMode = AppearanceMode.dark

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
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                List {
                    Group {
                        AppHeaderView()
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.appListRowBackground)

                    Section("Appearance") {
                        Picker("Theme", selection: $appearanceMode) {
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
                .background(Color.clear)
                .padding(.top, -40)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
