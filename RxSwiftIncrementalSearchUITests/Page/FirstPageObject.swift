import XCTest

class FirstPageObject: PageObject {
    private enum IDs {
        static let rootElement: String = "first_root_view"
        static let searchTextField: String = "search_textfield"
        static let resultTableView: String = "result_tableview"
        static let tabBarButtonSecond: String = "tab_bar_button_second"
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

    private var secondButton: XCUIElement { return app.buttons["Second"] }

    func typeTextSearchTextField(_ searchText: String) -> FirstPageObject {
        searchTextField.tap()
        searchTextField.typeText(searchText)
        return self
    }

//    func scrollTableViewOnePage() -> FirstPageObject {
//        sleep(2)
//        let lastCell = resultTableView.cells.allElementsBoundByIndex.last
//        let maxScrolls = 3
//        var count = 0
//        while lastCell?.isHittable == false && count < maxScrolls {
//            sleep(3)
//            app.swipeUp()
//            count += 1
//        }
//        lastCell?.tap()
//        return self
//    }

    func scrollUpDownTableView() -> FirstPageObject {
        sleep(2)
        app.swipeUp()
        sleep(2)
        app.swipeDown()
        sleep(2)
        return self
    }

    func selectTableViewCellFirst() -> ThirdPageObject {
        resultTableView.cells.firstMatch.tap()
        return ThirdPageObject(application: app)
    }

    func moveToSecondPage() -> SecondPageObject {
        secondButton.tap()
        return SecondPageObject(application: app)
    }
}

extension FirstPageObject {
    var existsPage: Bool {
        return view.exists
    }
}
