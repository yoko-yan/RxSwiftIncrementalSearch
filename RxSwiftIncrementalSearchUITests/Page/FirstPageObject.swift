import XCTest

class FirstPageObject: PageObject {
    private enum IDs {
        static let rootElement: String = "first_root_view"
        static let searchTextField: String = "search_textfield"
        static let resultTableView: String = "result_tableview"
        static let tabBarButtonSecond: String = "second"
    }

    private let app: XCUIApplication
    required init(application: XCUIApplication) {
        self.app = application
    }

    private var view: XCUIElement {
        return app.otherElements[IDs.rootElement]
    }

    private var searchTextField: XCUIElement {
        return view.searchFields[IDs.searchTextField]
    }

    private var resultTableView: XCUIElement {
        return view.tables[IDs.resultTableView]
    }

    private var secondTabButton: XCUIElement {
        print(XCUIApplication().debugDescription)
        return app.tabs.buttons[IDs.tabBarButtonSecond]
    }

    var searchResultCount: Int {
        return resultTableView.cells.count
    }

    func typeTextSearchTextField(_ searchText: String) -> FirstPageObject {
        searchTextField.tap()
        searchTextField.typeText(searchText)
        return self
    }

    func pageingResultTableView() -> FirstPageObject {
        let lastCell = resultTableView.cells.allElementsBoundByIndex.last
        while lastCell?.isHittable == false {
            app.swipeUp()
            sleep(2)
        }
        return self
    }

    func scrollUpResultTableView() -> FirstPageObject {
        app.swipeUp()
        return self
    }

    func scrollDownResultTableView() -> FirstPageObject {
        app.swipeDown()
        return self
    }

    func tapCellAndNextPage(index: Int) -> ThirdPageObject {
        resultTableView.cells.element(boundBy: index).tap()
        return ThirdPageObject(application: app)
    }

    func goToSecondPage() -> SecondPageObject {
        secondTabButton.tap()
        return SecondPageObject(application: app)
    }
}

extension FirstPageObject {
    var existsPage: Bool {
        return view.exists
    }
}
