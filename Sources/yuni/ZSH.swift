//
//  ZSH.swift
//  yuni
//
//  Created by Sherman Barros on 11/13/25.
//

import Teco

enum ZSH {
    static let exitCode = "%?"
    static let user = "%n"
    static let host = "%m"
    static let privilegeCharacter = "%#"
    
    @MainActor
    static func withColor<T>(_ color: Color, action: () throws -> T) rethrows -> T {
        if Terminal.shouldApplyStyles {
            Terminal.print("%F{\(color.rawValue)}", terminator: "")
        }
        let result = try action()
        if Terminal.shouldApplyStyles {
            Terminal.print("%f", terminator: "")
        }
        return result
    }
    
    @MainActor
    static func withBold<T>(action: () throws -> T) rethrows -> T {
        if Terminal.shouldApplyStyles {
            Terminal.print("%B", terminator: "")
        }
        let result = try action()
        if Terminal.shouldApplyStyles {
            Terminal.print("%b", terminator: "")
        }
        return result
    }
    
    @MainActor
    static func wrapExitCodes(onSuccess: (() -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        Terminal.print("%(?.", terminator: "")
        if let onSuccess {
            onSuccess()
        }
        Terminal.print(".", terminator: "")
        if let onFailure {
            onFailure()
        }
        Terminal.print(")", terminator: "")
    }

    enum Color: UInt8 {
        case red = 1
        case green
        case yellow
        case blue
        case magenta
    }
}
