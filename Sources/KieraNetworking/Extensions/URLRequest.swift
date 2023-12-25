import Foundation

public extension URLRequest {
    static func get(
        url: URL,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20,
        configuration: APIConfiguration = .shared
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = merge(headers, using: configuration)
        return urlRequest
    }
    
    static func post(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20,
        configuration: APIConfiguration = .shared
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = merge(headers, using: configuration)
        urlRequest.httpBody = data
        return urlRequest
    }
    
    static func put(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20,
        configuration: APIConfiguration = .shared
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "PUT"
        urlRequest.allHTTPHeaderFields = merge(headers, using: configuration)
        urlRequest.httpBody = data
        return urlRequest
    }
    
    static func path(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20,
        configuration: APIConfiguration = .shared
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "PATCH"
        urlRequest.allHTTPHeaderFields = merge(headers, using: configuration)
        urlRequest.httpBody = data
        return urlRequest
    }
    
    static func delete(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20,
        configuration: APIConfiguration = .shared
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "DELETE"
        urlRequest.allHTTPHeaderFields = merge(headers, using: configuration)
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension URLRequest {
    private static func merge(
        _ headers: [String: String],
        using configuration: APIConfiguration
    ) -> [String: String] {
        configuration.defaultHeaders.merging(headers) { (_, new) in new }
    }
}
