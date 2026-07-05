import SwiftUI

extension Color {
    static var appBackground: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? .black : .systemBackground
        })
    }

    static var appListRowBackground: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? .black : .systemBackground
        })
    }

    static var appListSeparator: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? .black : .separator
        })
    }

    static var appCardGradientTop: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
                : UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1)
        })
    }

    static var appCardGradientBottom: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.29, green: 0.17, blue: 0.35, alpha: 1)
                : UIColor(red: 0.88, green: 0.82, blue: 0.94, alpha: 1)
        })
    }

    static var appPrimaryText: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? .white : .label
        })
    }

    static var appSecondaryText: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? .lightGray : .secondaryLabel
        })
    }
}
