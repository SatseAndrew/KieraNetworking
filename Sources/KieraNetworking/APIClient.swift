import Foundation
import Combine
import Dependencies

open class APIClient {
    @Dependency(\.network) private var network
    
    public init() {}
    
    public func load<Request: APIRequest>(request: Request) async throws -> Request.Response {
        let urlRequest = try urlRequest(from: request)
        let networkResponse = try await network.data(for: urlRequest)
        
        guard networkResponse.statusCode.isSuccess else {
            throw APIError.server(
                error: APIServerError(
                    statusCode: networkResponse.statusCode,
                    body: networkResponse.data
                )
            )
        }
        
        let response = try decodeResponse(data: networkResponse.data, request: request)
        return response
    }
    
    public func loadEvents<Request: APIRequest>(
        request: Request
    ) -> AnyPublisher<Request.Response, APIError> {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try self.urlRequest(from: request)
        } catch {
            return Fail<Request.Response, APIError>(error: error as! APIError)
                .eraseToAnyPublisher()
        }
        
        let sseHandler = SSEHandler(request: request)
        let networkStream = network.dataPublisher(for: urlRequest)
        let eventStream = sseHandler.process(networkStream: networkStream)
        return eventStream.eraseToAnyPublisher()
    }
}

extension APIClient {
    private func urlRequest<Request: APIRequest>(from request: Request) throws -> URLRequest {
        do {
            return try request.urlRequest
        } catch {
            throw APIError.encodeRequestBody(error: error)
        }
    }
    
    private func decodeResponse<Request: APIRequest>(
        data: Data,
        request: Request
    ) throws -> Request.Response {
        do {
            return try request.response(from: data)
        } catch {
            throw APIError.decodeResponseBody(error: error)
        }
    }
}
