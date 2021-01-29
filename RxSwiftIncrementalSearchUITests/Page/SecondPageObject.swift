import XCTest

class SecondPageObject: PageObject {
    private enum IDs {
        static let rootElement: String = "second_root_view"
        static let loginIDTextField: String = "login_name_textfield"
        static let loginPassTextField: String = "login_password_textfield"
        static let tabBarButton: String = "tab_bar_button_second"
    }

    let app: XCUIApplication
    required init(application app: XCUIApplication) {
        self.app = app
    }

    private var view: XCUIElement {
        return app.otherElements[IDs.rootElement]
    }
}

extension SecondPageObject {
    var existsPage: Bool {
        return view.exists
    }
}
