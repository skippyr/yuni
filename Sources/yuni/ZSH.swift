//
//  ZSH.swift
//  Part of the yuni project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

import Teco

enum ZSH {
    static let exitCode = "%?"
    static let user = "%n"
    static let host = "%m"
    static let privilegeCharacter = "%#"

    @MainActor
    static func withColor<T>(_ color: Color, action: () throws -> T) rethrows -> T {
        if Terminal.shouldApplyColors {
            Terminal.print("%F{\(color.rawValue)}", terminator: "")
        }
        let result = try action()
        if Terminal.shouldApplyColors {
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
    static func withUnderline<T>(action: () throws -> T) rethrows -> T {
        if Terminal.shouldApplyStyles {
            Terminal.print("%U", terminator: "")
        }
        let result = try action()
        if Terminal.shouldApplyStyles {
            Terminal.print("%u", terminator: "")
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
