import XCTest
import APIKit
import RxSwift
import RxBlocking
import Library

@testable import WikipediaAPI

class WikipediSearchRequestTests: XCTestCase {
    func testRequest() {
        let expect = expectation(description: "fulfill")

        let sessionAdapter = TestSessionAdapter()
        let session = Session(adapter: sessionAdapter, callbackQueue: .sessionQueue)
        let request = WikipediaSearchRequest(word: "swift", offset: 10)

        session.send(request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.query.search.count, 10)
                let search = response.query.search .first!
                XCTAssertEqual(search.pageid, 499755)
                XCTAssertEqual(search.size, 4190)
                XCTAssertEqual(search.title, "スイフト")
                XCTAssertEqual(search.snippet, "スイフト、スウィフト（英語 <span class=\"searchmatch\">swift</span>, <span class=\"searchmatch\">SWIFT</span>）の原義は、「迅速」。転じて英語圏の姓など。 グレアム・スウィフト - イギリスの作家。 ジョナサン・スウィフト - アイルランドの作家。『ガリヴァー旅行記』の作者として著名。 ジョン・トランブル・スウィフト - アメリカの教育者。明治時代の日本で活動。")
                XCTAssertEqual(search.timestamp, "2020-01-18T06:47:30Z")
                XCTAssertEqual(search.updateDate, Date(dateString: "2020-01-18T06:47:30Z")!)
                XCTAssertEqual(search.wordcount, 383)

                let `continue` = response.continue
                XCTAssertEqual(`continue`?.sroffset, 10)

                expect.fulfill()
            case .failure(let error):
                XCTFail("failed \(error.localizedDescription)")
            }
        }

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.url(forResource: "search", withExtension: "json")
        let data = try? Data(contentsOf: path!)
        sessionAdapter.return(data: data!)

        waitForExpectations(timeout: 5)
    }
}
