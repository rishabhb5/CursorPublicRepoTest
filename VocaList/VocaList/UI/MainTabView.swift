// 20250605
// MainTabView

import SwiftUI

struct MainTabView: View {
    @AppStorage(SettingsKeys.appearanceMode) private var appearanceMode = AppearanceMode.dark

    // MARK: - BODY
    var body: some View {
        CustomTabHostView()
            .preferredColorScheme(appearanceMode.colorScheme)
    }
}
