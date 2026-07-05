import UIKit

extension UIColor {
    static var appBackground: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? .black : .systemBackground
        }
    }

    static var appListRowBackground: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? .black : .systemBackground
        }
    }

    static var appPurple: UIColor {
        UIColor(red: 0.54, green: 0.17, blue: 0.89, alpha: 1)
    }
}
