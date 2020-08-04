import Foundation
import APIKit

public struct WikipediaSearchRequest: RequestType {

    // MARK: - Property

    public static let srlimit = 10

    public typealias Response = WikipediaSearchResponse

    public let method: HTTPMethod = .get
    public let path = "/w/api.php"
    public let dataParser: DataParser = WikipediaParser()

    public var parameters: Any? {
        return [
            "format": "json",
            "action": "query",
            "list": "search",
            "srlimit": Self.srlimit,
            "srsearch": word,
            "sroffset": offset,
            "continue": "-||"
        ]
    }

    // MARK: - Initialize

    public let word: String
    public let offset: Int

    public init(word: String = "", offset: Int = 0) {
        self.word = word
        self.offset = offset
    }
}

// MARK: - Public
public extension WikipediaSearchRequest {

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(Response.self, from: data)
    }
}

// MARK: - Private
private extension WikipediaSearchRequest {

}
