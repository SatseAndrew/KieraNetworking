import Foundation

public class APIConfiguration {
    public var defaultHeaders: [String: String]
    public var jsonEncoder: JSONEncoder
    public var jsonDecoder: JSONDecoder
    
    public init(
        defaultHeaders: [String : String],
        jsonEncoder: JSONEncoder,
        jsonDecoder: JSONDecoder
    ) {
        self.defaultHeaders = defaultHeaders
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
}

public extension APIConfiguration {
    static var shared: APIConfiguration = .init(
        defaultHeaders: [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "User-Agent": userAgent
        ],
        jsonEncoder: JSONEncoder(),
        jsonDecoder: JSONDecoder()
    )
    
    private static var userAgent: String {
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "<unknown>"
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        return "\(bundleName)/\(bundleVersion)"
    }
}
