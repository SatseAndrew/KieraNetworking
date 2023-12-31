import Foundation

public protocol APIRequest {
    var urlRequest: URLRequest { get throws }
    func response(from data: Data) throws -> Response
    
    associatedtype Response
}

public extension APIRequest where Response == Data {
    func response(from data: Data) throws -> Response {
        data as Response
    }
}

public extension APIRequest where Response == Void {
    func response(from data: Data) throws -> Response {
        () as Response
    }
}

public extension APIRequest where Response: Decodable {
    func response(from data: Data) throws -> Response {
        let decoder = JSONDecoder()
        let response = try decoder.decode(Response.self, from: data)
        return response
    }
}
