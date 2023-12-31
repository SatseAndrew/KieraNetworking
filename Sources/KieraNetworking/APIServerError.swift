import Foundation

public struct APIServerError {
    public let statusCode: HTTPStatusCode
    public let body: Data
    
    public var bodyString: String {
        String(data: body, encoding: .utf8) ?? "<unknown>"
    }
}

extension APIServerError: LocalizedError {
    public var errorDescription: String? {
        "Status Code: \(statusCode.rawValue).\nBody: \(bodyString)"
    }
}
