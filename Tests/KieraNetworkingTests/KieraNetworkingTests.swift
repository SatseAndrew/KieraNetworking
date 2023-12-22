import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(KieraNetworkingMacros)
import KieraNetworkingMacros

let testMacros: [String: Macro.Type] = [
    "URL": URLMacro.self,
]
#endif

final class KieraNetworkingTests: XCTestCase {}
