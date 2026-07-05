// 20250605
// MainTabView

import SwiftUI

struct MainTabView: View {
    @AppStorage(SettingsKeys.appearanceMode) private var appearanceMode = AppearanceMode.dark

    // MARK: - BODY
    var body: some View {
        CustomTabHostView()
            .preferredColorScheme(appearanceMode.colorScheme)
            .onReceive(NotificationCenter.default.publisher(for: .appearanceModeDidChange)) { _ in
                if let rawValue = UserDefaults.standard.string(forKey: SettingsKeys.appearanceMode),
                   let mode = AppearanceMode(rawValue: rawValue) {
                    appearanceMode = mode
                }
            }
    }
}
