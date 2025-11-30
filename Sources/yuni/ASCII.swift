//
//  ASCII.swift
//  Part of the yuni project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

enum ASCII {
    static let slashValue = 47
    static let newlineValue = 10
    private static let digitsRange: ClosedRange<Int32> = 48...57
    private static let hexLettersRange: ClosedRange<Int32> = 97...102

    static func isHEXDigit(_ value: Int32) -> Bool {
        (digitsRange).contains(value) || (hexLettersRange).contains(value)
    }
}
