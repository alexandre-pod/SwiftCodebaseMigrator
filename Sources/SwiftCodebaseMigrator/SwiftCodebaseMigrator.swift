// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

@main
struct SwiftCodebaseMigrator: AsyncParsableCommand, Sendable {

    @Argument(help: "Path to a file or directory containing the source code you want to migrate")
    var path: String

    func validate() throws {
        guard FileManager.default.fileExists(atPath: path) else {
            throw ValidationError("Invalid path: \(path)")
        }
    }

    mutating func run() async throws {
        let fileURLs = getFileURLs()
        let fileRewriter = FileRewriter()

        var done = 0

        for fileURL in fileURLs {
            try fileRewriter.rewriteFile(at: fileURL)
            done += 1
            printOnCurrentLine("✅ [\(done)/\(fileURLs.count)] \(fileURL.relativePath)")
        }
        print()
    }

    // MARK: - Private

    private func getFileURLs() -> [URL] {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory),
              isDirectory.boolValue
        else {
            return [URL(filePath: path)]
        }
        return FileManager.default.getFiles(withSuffix: ".swift", inDirectory: URL(fileURLWithPath: path))
    }
}
