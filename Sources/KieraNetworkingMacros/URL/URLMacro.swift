import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments
        else {
            context.diagnose(Diagnostic(node: node, message: URLDiagnostics.argumentMissing))
            return ""
        }

        guard let _ = URL(string: segments.description) else {
            context.diagnose(Diagnostic(node: node, message: URLDiagnostics.malformedURL(segments.description)))
            return ""
        }

        return "URL(string: \(argument))!"
    }
}
