//
//  String+CLI.swift
//  Part of the yuni project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

extension String {
    var isCLIOption: Bool {
        wholeMatch(of: /^--?[A-Za-z0-9]+$/) != nil
    }
}
