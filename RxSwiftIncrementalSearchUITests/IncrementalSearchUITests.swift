import XCTest

class IncrementalSearchUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.app.launch()
    }

    func testIncrementalSearchSuccess() {
        let searchText = "aaa"
        XCTContext.runActivity(named: "インクリメンタルサーチ成功パターン") { _ in
            let firstPage = FirstPageObject(application: app)
            XCTAssertTrue(firstPage.existsPage)
            let thirdPage = firstPage
                .typeTextSearchTextField(searchText)
                .scrollUpDownTableView()
                .selectTableViewCellFirst()
            XCTAssertTrue(thirdPage.existsPage)
        }
    }

    func testLoginSuccess() {
        let searchText = "login"
        XCTContext.runActivity(named: "ログインテスト成功パターン") { _ in
            SecondPageObject(application: app)
//                .moveToLoginPage()
//                .enterEmailAddress(email)
//                .enterPassword(password)
//                .tapLoginButton()
        }
    }
}
