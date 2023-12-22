import Foundation
import SwiftDiagnostics

struct URLDiagnostics: DiagnosticMessage {
    let diagnosticID: MessageID
    let message: String
    let severity: DiagnosticSeverity
}

extension URLDiagnostics {
    static var argumentMissing: URLDiagnostics {
        URLDiagnostics(
            diagnosticID: MessageID(domain: "KieraNetworking", id: "argumentMissing"),
            message: "#URL requires a static string literal",
            severity: .error
        )
    }
    
    static func malformedURL(_ argument: String) -> URLDiagnostics {
        URLDiagnostics(
            diagnosticID: MessageID(domain: "KieraNetworking", id: "malformedURL"),
            message: "Malformed url: \(argument)",
            severity: .error
        )
    }
}
