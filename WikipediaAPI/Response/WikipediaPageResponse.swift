import Foundation

public struct WikipediaPageResponse: Decodable {
    public let query: PageQuery

    public struct PageQuery: Decodable {
        public let pages: [String: WikipediaPage]
    }
}

public struct WikipediaPage: Decodable {
    public let pageid: Int
    public let title: String
    public let extract: String
}

extension WikipediaPage: Equatable {
    public static func == (lhs: WikipediaPage, rhs: WikipediaPage) -> Bool {
        return lhs.pageid == rhs.pageid
    }

    public var url: URL {
        return URL(string: "https://ja.m.wikipedia.org/w/index.php?curid=\(pageid)")!
    }
}
