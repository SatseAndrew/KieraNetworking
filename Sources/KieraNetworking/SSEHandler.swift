import Foundation
import Combine
import OSLog

public class SSEHandler<Request: APIRequest> {
    private let request: Request
    private var buffer = Data()
    private var logger = Logger(subsystem: "KiraNetworking", category: "SSE")
    private var eventSubject = PassthroughSubject<Request.Response, APIError>()
    private var networkSubscription: AnyCancellable?
    
    private var eventStart: Data {
        "data: ".data(using: .utf8) ?? Data()
    }
    
    private var eventEnd: Data {
        "\n\n".data(using: .utf8) ?? Data()
    }
    
    private var eventCompletion: Data {
        "[DONE]".data(using: .utf8) ?? Data()
    }
    
    public init(request: Request) {
        self.request = request
    }
    
    public func process(
        networkStream: AnyPublisher<Data, URLError>
    ) -> AnyPublisher<Request.Response, APIError> {
        networkSubscription = networkStream
            .sink(
                receiveCompletion: handleStream(completion:),
                receiveValue: handleStream(data:)
            )
        
        return eventSubject.eraseToAnyPublisher()
    }
}

extension SSEHandler {
    private func handleStream(completion: Subscribers.Completion<URLError>) {
        switch completion {
        case .finished:
            eventSubject.send(completion: .finished)
        case let .failure(failure):
            eventSubject.send(completion: .failure(.network(error: failure)))
        }
    }
    
    private func handleStream(data: Data) {
        buffer.append(data)
        processBuffer()
    }
    
    private func processBuffer() {
        guard
            let startRange = buffer.range(of: eventStart),
            let endRange = buffer.range(of: eventEnd)
        else { return }
        
        let eventData = buffer.subdata(in: startRange.upperBound..<endRange.lowerBound)
        buffer.removeSubrange(0..<endRange.upperBound)
        
        guard eventData != eventCompletion else { return }
        
        do {
            let event = try request.response(from: eventData)
            eventSubject.send(event)
            logger.info("Server-Sent-Event published.")
        } catch {
            logger.error("Decoding Server-Sent-Event failed with error: \(error.localizedDescription)")
        }
        
        processBuffer()
    }
}
