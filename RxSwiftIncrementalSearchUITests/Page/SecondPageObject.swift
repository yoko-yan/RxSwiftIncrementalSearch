import XCTest

class SecondPageObject: PageObject {
    private enum IDs {
        static let rootElement: String = "second_root_view"
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
