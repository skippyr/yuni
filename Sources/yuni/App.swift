//
//  main.swift
//  yuni
//
//  Created by Sherman Barros on 11/10/25.
//

import Foundation
import Teco

@main enum App {
  private static let version = "1.0 (2)"
  @MainActor private static let titleStyle = Terminal.Style(foreground: .magenta, weight: .bold)
  @MainActor private static let optionStyle = Terminal.Style(foreground: .red)
  @MainActor private static let pathStyle = Terminal.Style(foreground: .green)
  @MainActor private static let urlStyle = Terminal.Style(foreground: .blue, effects: [.underline])

  static func environmentVariable(_ name: String) -> String? {
    if let value = getenv(name) { String(cString: value) } else { nil }
  }

  @MainActor static func throwError(_ message: Terminal.StyledString) -> Never {
    Terminal.print(
      """
      \("yuni:".style(titleStyle)) \(message)
      Use \("-h".style(optionStyle)) or \("--help".style(optionStyle)) for help instructions.
      """, via: .error)
    exit(EXIT_FAILURE)
  }

  @MainActor static func printHelp() {
    Terminal.print(
      """
      \("Usage:".style(titleStyle)) yuni [\("OPTION".style(optionStyle).underline)]...
      Writes the Yuni ZSH theme prompt using shell syntax.

      Use it via the script \("yuni.zsh-theme".style(pathStyle)) that comes in its bundle.

      For more information, read its \("README.md".style(pathStyle)).

      \("AVAILABLE OPTIONS".style(titleStyle))
          \("-h".style(optionStyle)), \("--help".style(optionStyle))     shows the software help instructions.
          \("-v".style(optionStyle)), \("--version".style(optionStyle))  shows the software version.
      """)
  }

  @MainActor static func printVersion() {
    Terminal.print(
      """
      \("yuni".style(titleStyle)) \(version.description.green) \("(xyz.dragonscave.yuni)".gray)
      Available at: \("https://github.com/skippyr/yuni".style(urlStyle)).

      MIT License
      Copyright (c) 2025 Sherman Barros <\("skippyr.developer@icloud.com".style(urlStyle))>

      Refer to the \("LICENSE".style(pathStyle)) file that comes in its source code for more details.
      """)
  }

  @MainActor static func printIDSSection() {
    ZSH.withBold {
      ZSH.withColor(.green) { Terminal.print(ZSH.user, terminator: "") }
      ZSH.withColor(.red) { Terminal.print("@", terminator: "") }
      ZSH.withColor(.green) { Terminal.print(ZSH.host, terminator: "") }
    }
  }

  @MainActor static func printVirtualEnvSection() {
    if let virtualEnv = environmentVariable("VIRTUAL_ENV") {
      Terminal.print(" (\(FileSystem.fileName(of: virtualEnv)))", terminator: "")
    }
    Terminal.print("  ", terminator: "")
  }

  @MainActor static func printPathSection(repository: Git.Repository?) {
    ZSH.withColor(.red) {
      var path: String = FileSystem.currentLogicalPath
      let isAbbreviatingRepository = if let path = repository?.path { path != "/" } else { false }
      var isReplacingRange = false
      if isAbbreviatingRepository {
        path.replaceSubrange(
          path.range(of: URL(fileURLWithPath: repository!.path).deletingLastPathComponent().path)!,
          with: "@")
        isReplacingRange = true
      } else {
        if let homeRange = path.range(of: FileManager.default.homeDirectoryForCurrentUser.path) {
          path.replaceSubrange(homeRange, with: "~")
          isReplacingRange = true
        }
      }
      if path.starts(with: "/") { Terminal.print("/", terminator: "") }
      let fragments = path.split(separator: "/")
      for (offset, fragment) in fragments.enumerated() {
        if offset > 0 { Terminal.print("/", terminator: "") }
        guard
          !((offset == 0 && isReplacingRange) || (isAbbreviatingRepository && offset == 1)
            || offset == fragments.count - 1)
        else {
          Terminal.print(fragment, terminator: "")
          continue
        }
        let start = fragment.startIndex
        let end = fragment.starts(with: ".") ? fragment.index(after: start) : start
        Terminal.print(fragment[start...end], terminator: "")
      }
    }
  }

  @MainActor static func printGitSection(repository: Git.Repository?) {
    guard let repository = repository else { return }
    ZSH.withColor(.blue) { Terminal.print(" git:(", terminator: "") }
    switch repository.reference {
    case .branch(let branch): ZSH.withColor(.yellow) { Terminal.print(branch, terminator: "") }
    case .rebaseHash(let rebaseHash):
      ZSH.withColor(.magenta) { Terminal.print("rebase:") }
      ZSH.withColor(.yellow) { Terminal.print(rebaseHash, terminator: "") }
    }
    ZSH.withColor(.blue) { Terminal.print(")", terminator: "") }
  }

  @MainActor static func printPrivilegeSection() {
    Terminal.print(" \(ZSH.privilegeCharacter)", terminator: "")
    if !FileSystem.canModifyCurrentDirectory {
      Terminal.print("[", terminator: "")
      ZSH.withColor(.red) { Terminal.print("!", terminator: "") }
      Terminal.print("]", terminator: "")
    }
  }

  @MainActor static func printExitCodeSection() {
    ZSH.wrapExitCodes(onFailure: {
      Terminal.print("[", terminator: "")
      ZSH.withColor(.red) { Terminal.print(ZSH.exitCode, terminator: "") }
      Terminal.print("] ", terminator: "")
    })
  }

  @MainActor static func printPrompt() {
    let repository = Git.Repository.active
    ZSH.withBold { ZSH.withColor(.red) { Terminal.print("⤐  ", terminator: "") } }
    printExitCodeSection()
    printIDSSection()
    printVirtualEnvSection()
    printPathSection(repository: repository)
    printGitSection(repository: repository)
    printPrivilegeSection()
    Terminal.print(" ")
  }

  static func main() {
    for argument in CommandLine.arguments.dropFirst().map({ $0.trimmingCharacters(in: .newlines) })
    {
      switch argument {
      case "-h", "--help":
        printHelp()
        exit(EXIT_SUCCESS)
      case "-v", "--version":
        printVersion()
        exit(EXIT_SUCCESS)
      default:
        throwError(
          "unrecognized \(argument.isCLIOption ? "option" : "argument") \"\(argument)\" provided.")
      }
    }
    printPrompt()
  }
}
