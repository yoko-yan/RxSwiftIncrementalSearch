import XCTest

protocol PageObject: PageObjectAssertion {
    init(application: XCUIApplication)
}

protocol PageObjectAssertion {
    var existsPage: Bool { get }
}

extension PageObject {
    func wait(second: UInt32) -> Self {
        sleep(second)
        return self
    }
}
