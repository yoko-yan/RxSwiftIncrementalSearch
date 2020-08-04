import APIKit

public class WikipediaParser: DataParser {
    public var contentType: String? {
        return "application/json; charset=UTF-8"
    }

    public func parse(data: Data) throws -> Any {
        return data
    }
}
