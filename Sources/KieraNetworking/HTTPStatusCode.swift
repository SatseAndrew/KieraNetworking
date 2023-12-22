import Foundation

public enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206

    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case temporaryRedirect = 307
    case permanentRedirect = 308

    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406

    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    
    public var isSuccess: Bool { category == .success }

    public var category: Category {
        switch self.rawValue {
        case 200..<300:
            return .success
        case 300..<400:
            return .redirection
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .unknown
        }
    }

    public enum Category {
        case success, redirection, clientError, serverError, unknown
    }
}


