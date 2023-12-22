import Foundation

public extension URLRequest {
    static func get(
        url: URL,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
    
    static func post(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = data
        return urlRequest
    }
    
    static func put(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "PUT"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = data
        return urlRequest
    }
    
    static func path(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "PATCH"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = data
        return urlRequest
    }
    
    static func delete(
        url: URL,
        data: Data,
        headers: [String: String] = [:],
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) -> URLRequest {
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        urlRequest.httpMethod = "DELETE"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = data
        return urlRequest
    }
}
