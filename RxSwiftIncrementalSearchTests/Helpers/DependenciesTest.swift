import Foundation
import APIKit
import RxSwift
import RxBlocking

@testable import RxSwiftIncrementalSearch
@testable import WikipediaAPI

struct DependenciesTest: Dependencies {
    let session: Session

    init(session: Session = Session(adapter: TestSessionAdapter(), callbackQueue: .sessionQueue)) {
        self.session = session
    }
}

extension DependenciesTest {
    var adapter: TestSessionAdapter {
        // swiftlint:disable force_cast
        return session.adapter as! TestSessionAdapter
        // swiftlint:enable force_cast
    }
}
