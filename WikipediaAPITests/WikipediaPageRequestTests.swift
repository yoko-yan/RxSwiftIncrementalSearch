import XCTest
import APIKit
import RxSwift
import RxBlocking
import Library

@testable import WikipediaAPI

class WikipediaPageRequestTests: XCTestCase {
    func testRequest() {
        let expect = expectation(description: "fulfill")

        let sessionAdapter = TestSessionAdapter()
        let session = Session(adapter: sessionAdapter, callbackQueue: .sessionQueue)
        let request = WikipediaPageRequest(pageid: 4126)

        session.send(request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.query.pages.count, 1)
                let page = response.query.pages .first!
                let value = page.value
                XCTAssertEqual(page.key, "4126")
                XCTAssertEqual(value.pageid, 4126)
                XCTAssertEqual(value.title, "通貨")
                XCTAssertEqual(value.extract, "通貨（つうか、英: currency）とは、流通貨幣の略称で、決済のための価値交換媒体。通貨を発行する国家もしくは、その地の統治主体の信用によって価値が変動する。その流通域での財政破綻や、信用が失墜する事によって、通貨の価値が無くなって紙切れになる場合もある。 通貨が無い時代の決済手段とされていた物々交換から、さらにモノやサービスの流動性を高めるために作られた経済形態である。 政府は租税の算定にあたって通貨を利用する。 モノやサービスとの交換に用いられる「お金（おかね）」を、経済用語では貨幣、または通貨と呼ぶ。通貨は、現金通貨と預金通貨に大別され、前者は紙幣・硬貨（補助紙幣）であり、後者は普通預金・当座預金などの決済口座である。")
                XCTAssertEqual(value.url, URL(string: "https://ja.m.wikipedia.org/w/index.php?curid=\(value.pageid)")!)

                expect.fulfill()
            case .failure(let error):
                XCTFail("failed \(error.localizedDescription)")
            }
        }

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.url(forResource: "page", withExtension: "json")
        let data = try? Data(contentsOf: path!)
        sessionAdapter.return(data: data!)

        waitForExpectations(timeout: 5)
    }
}
