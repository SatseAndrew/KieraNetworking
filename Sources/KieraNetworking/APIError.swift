import Foundation

public enum APIError {
    case createRequest(error: Error)
    case networking(error: URLError)
    case server(statusCode: HTTPStatusCode, body: Data)
    case decodeResponse(error: Error)
    case timeout
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .createRequest(error):
            "Create URLRequest failed with error: \(error.localizedDescription)"
        case let .networking(error):
            "The request failed with error: \(error.localizedDescription)"
        case let .server(statusCode, _):
            "The server returned with status code: \(statusCode)"
        case let .decodeResponse(error):
            "Decoding the response failed with error: \(error.localizedDescription)"
        case .timeout:
            "The request timed out."
        }
    }
}
