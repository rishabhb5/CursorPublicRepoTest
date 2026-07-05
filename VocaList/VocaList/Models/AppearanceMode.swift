import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable, Hashable {
    case dark
    case light
    case system

    var id: String { rawValue }

    var label: String {
        switch self {
        case .dark: return "Dark"
        case .light: return "Light"
        case .system: return "System"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .dark: return .dark
        case .light: return .light
        case .system: return nil
        }
    }
}

enum SettingsKeys {
    static let appearanceMode = "appearanceMode"
}

extension Notification.Name {
    static let appearanceModeDidChange = Notification.Name("appearanceModeDidChange")
}
