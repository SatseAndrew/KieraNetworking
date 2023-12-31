import Foundation

public enum APIError {
    case encodeRequestBody(error: Error)
    case network(error: URLError)
    case server(error: APIServerError)
    case decodeResponseBody(error: Error)
    case timeout
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .encodeRequestBody(error):
            "Create URLRequest failed with error: \(error.localizedDescription)"
        case let .network(error):
            "The request failed with error: \(error.localizedDescription)"
        case let .server(error):
            "The server returned with status code: \(error.statusCode)"
        case let .decodeResponseBody(error):
            "Decoding the response failed with error: \(error.localizedDescription)"
        case .timeout:
            "The request timed out."
        }
    }
}
