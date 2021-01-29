import XCTest

class ThirdPageObject: PageObject {
    private enum IDs {
        static let rootElement: String = "third_root_view"
    }

    let app: XCUIApplication
    required init(application app: XCUIApplication) {
        self.app = app
    }

    private var view: XCUIElement {
        return app.otherElements[IDs.rootElement]
    }
}

extension ThirdPageObject {
    var existsPage: Bool {
        return view.exists
    }
}
