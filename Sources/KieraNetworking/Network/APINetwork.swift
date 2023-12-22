import Foundation
import Combine

public class APINetwork: NSObject {
    private var urlSession: URLSession = .shared
    private var dataTaskSubjects: [Int: PassthroughSubject<Data, URLError>] = [:]
    
    public init(configuration: URLSessionConfiguration = .default) {
        super.init()        
        self.urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
}

extension APINetwork: Network {
    public func data(for urlRequest: URLRequest) async throws -> NetworkResponse {
        let response = try await urlSession.data(for: urlRequest)
        
        guard
            let httpResponse = response.1 as? HTTPURLResponse,
            let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode)
        else { throw URLError(.unknown) }
        
        return NetworkResponse(
            data: response.0,
            statusCode: statusCode
        )
    }
    
    public func dataPublisher(for urlRequest: URLRequest) -> AnyPublisher<Data, URLError> {
        let dataTask = urlSession.dataTask(with: urlRequest)
        let dataSubject = PassthroughSubject<Data, URLError>()
        dataTaskSubjects[dataTask.taskIdentifier] = dataSubject
        dataTask.resume()
        return dataSubject.eraseToAnyPublisher()
    }
}

extension APINetwork: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let dataSubject = dataTaskSubjects[dataTask.taskIdentifier] else { return }
        dataSubject.send(data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let taskId = task.taskIdentifier
        
        guard let subject = dataTaskSubjects[taskId] else {
            return
        }
        
        if let urlError = error as? URLError {
            subject.send(completion: .failure(urlError))
        } else {
            subject.send(completion: .finished)
        }
        
        if let subjectIndex = dataTaskSubjects.index(forKey: taskId) {
            dataTaskSubjects.remove(at: subjectIndex)
        }
    }
}

