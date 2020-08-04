import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import APIKit

@testable import RxSwiftIncrementalSearch
//@testable import WikipediaAPI

class FirstViewModelTests: XCTestCase {
    private var dependencies: DependenciesTest!
    private var scheduler: SchedulerType!
    private var disposeBag = DisposeBag()

    override func setUp() {
        dependencies = DependenciesTest()
        scheduler = MainScheduler.instance
        disposeBag = DisposeBag()
    }

    func setUpMockResponseData(fixtureFileName: String) {
        let data = TestSessionAdapter().createData(fixtureFileName: fixtureFileName)
        dependencies.adapter.data = data
    }

    func testIncrementalSearch() {
        let viewModel: FirstViewModel = .init(dependencies: dependencies, scheduler:  scheduler)

        let viewDidReachBottom: PublishRelay<Void> = .init()
        let pullToRefreshTrigger: PublishRelay<Void> = .init()
        let incrementalSearchTrigger: PublishRelay<String> = .init()

        let input: FirstViewModel.Input = .init(
            viewDidReachBottom: viewDidReachBottom.asObservable(),
            pullToRefreshTrigger: pullToRefreshTrigger.asObservable(),
            incrementalSearchTrigger: incrementalSearchTrigger.asObservable()
        )

        let output = viewModel.transform(input: input)

        asyncAfter(.milliseconds(500)) {
            incrementalSearchTrigger.accept("s")
        }
        asyncAfter(.milliseconds(1000)) { // it should be 1.0 sec interval.
            self.setUpMockResponseData(fixtureFileName: "search1.json")
            incrementalSearchTrigger.accept("swi")
        }
        asyncAfter(.milliseconds(1500)) { // it should be 1.0 sec interval.
            self.setUpMockResponseData(fixtureFileName: "search1.json")
            incrementalSearchTrigger.accept("swif")
        }

        // swiftlint:disable force_try
        let results = try! output.searchStream.take(2).toBlocking().toArray()
        // swiftlint:enable force_try

//        let count = WikipediaSearchRequest.srlimit
        let count = 10
        XCTAssertEqual(results.map { $0.count }, [count, count])

        dump(results)
    }

    func testPaginationRequest() {
        let viewModel: FirstViewModel = .init(dependencies: dependencies, scheduler:  scheduler)

        let viewDidReachBottom: PublishRelay<Void> = .init()
        let pullToRefreshTrigger: PublishRelay<Void> = .init()
        let incrementalSearchTrigger: PublishRelay<String> = .init()

        let input: FirstViewModel.Input = .init(
            viewDidReachBottom: viewDidReachBottom.asObservable(),
            pullToRefreshTrigger: pullToRefreshTrigger.asObservable(),
            incrementalSearchTrigger: incrementalSearchTrigger.asObservable()
        )

        let output = viewModel.transform(input: input)

        asyncAfter(.milliseconds(500)) {
            self.setUpMockResponseData(fixtureFileName: "search1.json")
            incrementalSearchTrigger.accept("swi")
        }
        asyncAfter(.milliseconds(1500)) { // it should be 1.0 sec interval.
            self.setUpMockResponseData(fixtureFileName: "search2.json")
            viewDidReachBottom.accept(())
        }
        asyncAfter(.milliseconds(2500)) { // it should be 1.0 sec interval.
            self.setUpMockResponseData(fixtureFileName: "search3.json")
            viewDidReachBottom.accept(())
        }

        // swiftlint:disable force_try
        let results = try! output.searchStream.take(3).toBlocking().toArray()
        // swiftlint:enable force_try

        XCTAssertEqual(results.map { $0.count }, [10, 20, 23])

        dump(results)
    }
}
