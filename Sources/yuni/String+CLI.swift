//
//  String+CLI.swift
//  yuni
//
//  Created by Sherman Barros on 11/11/25.
//

extension String { var isCLIOption: Bool { wholeMatch(of: /^--?[A-Za-z0-9]+$/) != nil } }
