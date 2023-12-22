import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KieraNetworkingPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
    ]
}
