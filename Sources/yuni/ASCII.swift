//
//  ASCII.swift
//  yuni
//
//  Created by Sherman Barros on 11/11/25.
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
