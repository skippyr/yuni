//
//  FileSystem.swift
//  Part of the yuni project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

import Foundation

enum FileSystem {
    static var currentLogicalPath: String {
        let physicalPath = FileManager.default.currentDirectoryPath
        guard let pwd = getenv("PWD") else {
            return physicalPath
        }
        let logicalPath = String(cString: pwd)
        return if let resolvedLogicalPath = realPath(of: .init(cString: pwd)), resolvedLogicalPath == physicalPath {
            logicalPath
        } else {
            physicalPath
        }
    }

    private static func realPath(of relativePath: String) -> String? {
        guard FileManager.default.fileExists(atPath: relativePath) else {
            return nil
        }
        let absolutePath = realpath(relativePath, nil)!
        defer {
            free(absolutePath)
        }
        return .init(cString: absolutePath)
    }

    static func fileName(of path: String) -> String {
        return URL(fileURLWithPath: path).lastPathComponent
    }

    static var canModifyCurrentDirectory: Bool {
        access(".", W_OK) == 0
    }
}
