import Foundation
import APIKit

public struct WikipediaPageRequest: RequestType {

    // MARK: - Property

    public typealias Response = WikipediaPageResponse

    public let method: HTTPMethod = .get
    public let path = "/w/api.php"
    public let dataParser: DataParser = WikipediaParser()

    public var parameters: Any? {
        return [
            "format": "json",
            "action": "query",
            "prop": "extracts",
            "exintro": "explaintext",
            "pageids": pageid
        ]
    }

    // MARK: - Initialize

    public let pageid: Int

    public init(pageid: Int) {
        self.pageid = pageid
    }
}

// MARK: - Public
public extension WikipediaPageRequest {
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
private extension WikipediaPageRequest {

}
