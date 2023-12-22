import Foundation
import Combine

public struct NetworkResponse {
    public let data: Data
    public let statusCode: HTTPStatusCode
}

public protocol Network {
    func data(for urlRequest: URLRequest) async throws -> NetworkResponse
    func dataPublisher(for urlRequest: URLRequest) -> AnyPublisher<Data, URLError>
}
