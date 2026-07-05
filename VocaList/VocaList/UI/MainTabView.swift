// 20250605
// MainTabView

import SwiftUI

struct MainTabView: View {
    @AppStorage(SettingsKeys.appearanceMode) private var appearanceModeRaw = AppearanceMode.dark.rawValue

    private var appearanceMode: AppearanceMode {
        AppearanceMode(rawValue: appearanceModeRaw) ?? .dark
    }

    // MARK: - BODY
    var body: some View {
        CustomTabHostView()
            .preferredColorScheme(appearanceMode.colorScheme)
    }
}
