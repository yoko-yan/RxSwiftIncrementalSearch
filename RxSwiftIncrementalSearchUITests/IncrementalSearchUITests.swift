import XCTest

class IncrementalSearchUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.app.launch()
    }

    func testGoToSecondPage() {
        XCTContext.runActivity(named: "goto tab2") { _ in
            let firstPage = FirstPageObject(application: app)
            XCTAssertTrue(firstPage.existsPage)
            let secondPage = firstPage
                .goToSecondPage()
            XCTAssertTrue(secondPage.existsPage)
        }
    }

    func testIncrementalSearchAndPaging() {
        let searchText = "aaa"
        XCTContext.runActivity(named: "paging") { _ in
            let firstPage = FirstPageObject(application: app)
            XCTAssertTrue(firstPage.existsPage)
            _ = firstPage
                .typeTextSearchTextField(searchText)
                .wait(second: 2)
                .pageingResultTableView()
                .wait(second: 2)
            XCTAssertEqual(firstPage.searchResultCount, 20)
        }
    }

    func testIncrementalSearchAndMoveToNextPage() {
        let searchText = "aaa"
        XCTContext.runActivity(named: "show thirdPage") { _ in
            let firstPage = FirstPageObject(application: app)
            XCTAssertTrue(firstPage.existsPage)
            let thirdPage = firstPage
                .typeTextSearchTextField(searchText)
                .wait(second: 2)
                .tapCellAndNextPage(index: 0)
                .wait(second: 2)
            XCTAssertTrue(thirdPage.existsPage)
        }
    }
}
