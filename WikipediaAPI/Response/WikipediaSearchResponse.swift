import Foundation
import Library

public struct WikipediaSearchResponse: Decodable {
    public let query: SearchQuery
    public let `continue`: Continue?

    public struct SearchQuery: Decodable {
        public let search: [WikipediaSearch]

    }

    public struct Continue: Decodable {
        public let sroffset: Int
        public let `continue`: String
    }
}

public struct WikipediaSearch {
    public let title: String
    public let pageid: Int
    public let size: Int
    public let wordcount: Int
    public let snippet: String
    public let timestamp: String
}

extension WikipediaSearch: Equatable {
    public static func == (lhs: WikipediaSearch, rhs: WikipediaSearch) -> Bool {
        return lhs.pageid == rhs.pageid
    }
}

extension WikipediaSearch: Decodable {

    public var updateDate: Date {
        if let date = Date(dateString: timestamp) {
            return date
        } else {
            assertionFailure()
            return Date()
        }
    }
}
