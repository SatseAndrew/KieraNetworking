# KiraNetworking Library

## Introduction
**KiraNetworking** is a modern, powerful, and easy-to-use networking library for Swift. Designed to streamline the process of making network requests and handling responses, this library simplifies working with REST APIs, real-time data streams, and more. Its primary goal is to enhance developer productivity while ensuring robust and efficient networking in Swift applications.

## Features
- **Async/Await Support:** Leverages Swift's latest concurrency features for clear and concise network calls.
- **Combine Framework Integration:** Offers seamless integration with Combine for reactive programming.
- **Server-Sent Events (SSE) Handling:** Efficiently manage real-time data streams.
- **Extensive HTTP Status Code Handling:** Rich enumeration for HTTP status codes with category-wise classification.
- **Error Handling:** Comprehensive error types covering a wide range of networking issues.
- **Swift Package Manager Support:** Easy to integrate into your project with SwiftPM.

## Requirements
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation
### Swift Package Manager
Add the following to your `Package.swift` file under `dependencies`:
```swift
.package(url: "https://github.com/yourusername/KiraNetworking.git", from: "1.0.0")
```

## Quick Start Guide
To make a GET request:
```swift
// First, define a request
struct GetTodoItemsRequest: APIRequest {
    var urlRequest: URLRequest {
        get throws { URLRequest.get(url: #URL("mycompany.org/api/todos")) }
    }
    typealias Response = [TodoItem]
}

// Then, define a client that subclasses APIClient
class TodoClient {
    func fetchTodos() async throws -> [TodoItem] {
        try await load(request: GetTodoItemsRequest())
    }
}

// Finally, invoke the method on the client
Task {
    do {
        let client = TodoClient()
        let todos = try await client.fetchTodos()
        // Handle response
    } catch {
        // Handle error
    }
}
```

## Detailed Usage

### Subclassing `APIClient`
Create custom clients by subclassing `APIClient`. This allows you to define specific methods for your API needs.

#### Example: Creating a Todo Client
To handle fetching todo items, subclass `APIClient` and define a method for the request:

```swift
class TodoClient: APIClient {
    func fetchTodos() async throws -> [TodoItem] {
        try await load(request: GetTodoItemsRequest())
    }
}
```

#### Using the Todo Client
With `TodoClient` set up, you can now fetch todo items easily:

```swift
let todoClient = TodoClient()

Task {
    do {
        let todos: [TodoItem] = try await todoClient.fetchTodos()
        // Process todo items
    } catch {
        // Handle errors
    }
}
```

#### Real-Time Event Handling
For real-time updates, such as receiving live todo item changes, use `loadEvents` in a similar fashion:

```swift
class TodoClient: APIClient {
    func todoUpdates() -> AnyPublisher<[TodoItem], APIError> {
        loadEvents(request: TodoUpdatesRequest())
    }
}
```

Then subscribe to the updates:

```swift
let todoClient = TodoClient()
todoClient.todoUpdates()
    .sink(
        receiveCompletion: { completion in
            // Handle completion or errors
        },
        receiveValue: { updatedTodos in
            // Handle real-time todo updates
        }
    )
    .store(in: &cancellables)
```

This approach centralizes your API logic within specific client classes, making your code cleaner and more manageable.

## Error Handling
Handle different error scenarios for robust error management:
```swift
Task {
    do {
        let response = try await client.load(request: yourRequest)
        // Process response
    } catch let error as APIError {
        // Handle APIError
    } catch {
        // Handle other errors
    }
}
```

## Customization and Extension
KiraNetworking is designed for extensibility. You can implement custom decoders, modify session configurations, and more.
