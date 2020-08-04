import APIKit
import Library

protocol RequestType: Request {
}

extension RequestType {

    public var baseURL: URL {
        return URL(string: "https://ja.wikipedia.org")!
    }

    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        Log.info("requestURL: \(urlRequest)")
        Log.info("requestBody: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8)?.debugDescription ?? "")")
        return urlRequest
    }

    public func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        Log.info("raw response header: \(urlResponse)")
        Log.info("raw response body: \(String(data: (object as? Data) ?? Data(), encoding: .utf8)?.debugDescription ?? "")")
        let statusCode = urlResponse.statusCode

        switch statusCode {
        case 200..<300:
            return object

        default:
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
    }
}
