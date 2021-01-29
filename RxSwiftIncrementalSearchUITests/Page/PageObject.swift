import XCTest

protocol PageObject: PageObjectAssertion {
    init(application: XCUIApplication)
}

protocol PageObjectAssertion {
    var existsPage: Bool { get }
}
