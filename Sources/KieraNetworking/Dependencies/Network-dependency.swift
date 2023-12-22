import Foundation
import Dependencies

public enum NetworkKey: DependencyKey {
    public static var liveValue: Network {
        APINetwork()
    }
}

public extension DependencyValues {
    var network: Network {
        get { self[NetworkKey.self] }
        set { self[NetworkKey.self] = newValue }
    }
}
