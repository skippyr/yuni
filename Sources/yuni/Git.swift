//
//  Git.swift
//  yuni
//
//  Created by Sherman Barros on 11/11/25.
//

import Foundation

enum Git {
    struct Repository {
        let path: String
        let reference: Reference
        
        private init(path: String, reference: Reference) {
            self.path = path
            self.reference = reference
        }
        
        private static func unsafeParseHead(at path: UnsafeMutableBufferPointer<CChar>, sentinelOffset: Int) -> Repository? {
            guard let file = fopen(path.baseAddress!, "r") else {
                return nil
            }
            defer { fclose(file) }
            return withUnsafeTemporaryAllocation(of: CChar.self, capacity: 256) { buffer in
                var matchesBranch = true
                var matchesRebaseHash = true
                for (offset, branchMatchingByte) in "ref: re".utf8.enumerated() {
                    if !matchesBranch && !matchesRebaseHash {
                        return nil
                    }
                    let readByte = fgetc(file)
                    guard readByte != EOF else {
                        return nil
                    }
                    if readByte != branchMatchingByte {
                        matchesBranch = false
                    }
                    if !ASCII.isHEXDigit(readByte) {
                        matchesRebaseHash = false
                    }
                    if matchesRebaseHash {
                        buffer[offset] = CChar(readByte)
                    }
                }
                if matchesRebaseHash {
                    path[sentinelOffset] = 0
                    buffer[7] = 0
                    return Repository(path: String(cString: path.baseAddress!), reference: .rebaseHash(String(cString: buffer.baseAddress!)))
                }
                for branchMatchingByte in "fs/heads/".utf8 {
                    let readByte = fgetc(file)
                    guard readByte != EOF && readByte == branchMatchingByte else {
                        return nil
                    }
                }
                var offset = 0
                while (true) {
                    guard offset < buffer.count else {
                        break
                    }
                    let readByte = fgetc(file)
                    guard readByte != EOF && readByte != ASCII.newlineValue else {
                        if offset == 0 {
                            return nil
                        } else {
                            break
                        }
                    }
                    buffer[offset] = CChar(readByte)
                    offset += 1
                }
                path[sentinelOffset] = 0
                buffer[offset] = 0
                return Repository(path: String(cString: path.baseAddress!), reference: .branch(String(cString: buffer.baseAddress!)))
            }
        }
        
        static var active: Repository? {
            let currentDirectoryPathUTF8 = FileSystem.currentLogicalPath.utf8
            return withUnsafeTemporaryAllocation(of: CChar.self, capacity: currentDirectoryPathUTF8.count + 11) { repositoryPath in
                for (offset, byte) in currentDirectoryPathUTF8.enumerated() {
                    (repositoryPath.baseAddress! + offset).pointee = CChar(bitPattern: byte)
                }
                var slashOffsets: [Int]?
                var currentSlashOffset = 0
                var sentinelOffset = currentDirectoryPathUTF8.count
                var isRootDirectory: Bool?
                while (true) {
                    memcpy(repositoryPath.baseAddress! + sentinelOffset, "/.git/HEAD", 11)
                    if let repository = unsafeParseHead(at: repositoryPath, sentinelOffset: sentinelOffset) {
                        return repository
                    }
                    repositoryPath[sentinelOffset] = 0
                    if isRootDirectory == nil {
                        isRootDirectory = currentDirectoryPathUTF8.count == 1
                        if !isRootDirectory! {
                            var totalSlashes = 0
                            for offset in 0..<currentDirectoryPathUTF8.count {
                                if repositoryPath[offset] == ASCII.slashValue {
                                    totalSlashes += 1
                                }
                            }
                            if totalSlashes > 1 {
                                slashOffsets = []
                                slashOffsets!.reserveCapacity(totalSlashes - 1)
                                var offset = currentDirectoryPathUTF8.count - 1
                                while (offset > 0) {
                                    defer { offset -= 1 }
                                    if repositoryPath[offset] == ASCII.slashValue {
                                        slashOffsets!.append(offset)
                                    }
                                }
                            }
                        }
                    }
                    if isRootDirectory! {
                        break
                    }
                    if slashOffsets == nil || currentSlashOffset == slashOffsets!.count - 1 {
                        sentinelOffset = 1
                        repositoryPath[sentinelOffset] = 0
                        isRootDirectory = true
                    } else {
                        sentinelOffset = slashOffsets![currentSlashOffset]
                        repositoryPath[sentinelOffset] = 0
                        currentSlashOffset += 1
                    }
                }
                return nil
            }
        }
    }
    
    enum Reference {
        case branch(String)
        case rebaseHash(String)
    }
}
