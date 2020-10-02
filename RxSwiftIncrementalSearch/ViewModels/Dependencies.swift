import Foundation
import APIKit

protocol Dependencies {
    var session: Session { get }
}

struct DependenciesImpl: Dependencies {
    let session: Session

    init(
        session: Session = Session.shared
    ) {
        self.session = session
    }
}
