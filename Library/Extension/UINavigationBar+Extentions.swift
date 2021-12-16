import UIKit

public extension UINavigationBar {

    class func applyNavigationColor() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().standardAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.white
        }
    }
}
