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
            eventSubject.send(completion: .failure(.networking(error: failure)))
        }
    }
    
    private func handleStream(data: Data) {
        buffer.append(data)
        processBuffer()
    }
    
    private func processBuffer() {
        guard
            let eventStartRange = buffer.range(of: eventStart),
            let eventEndRange = buffer.range(of: eventEnd)
        else { return }
        
        let eventData = buffer.subdata(in: eventStartRange.upperBound..<eventEndRange.lowerBound)
        buffer.removeSubrange(0..<eventEndRange.upperBound)
        
        guard eventData != eventCompletion else { return }
        
        do {
            let event = try request.response(from: eventData)
            eventSubject.send(event)
            logger.info("Event published")
        } catch {
            logger.error("Decoding event failed with error: \(error.localizedDescription)")
        }
        
        processBuffer()
    }
}
