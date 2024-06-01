//
//  FileRewriter.swift
//  
//
//  Created by Alexandre Podlewski on 02/06/2024.
//

import Foundation
import SwiftSyntax
import SwiftParser

struct FileRewriter {

    func rewriteFile(at fileURL: URL) throws {
        let file = try String(contentsOf: fileURL)
        let migratedFile = rewriteSourceCode(file)
        try migratedFile.data(using: .utf8)?.write(to: fileURL)
    }

    // MARK: - Private

    private func rewriteSourceCode(_ fileContent: String) -> String {
        var sourceFile = Parser.parse(source: fileContent) as SyntaxProtocol
        for rewriter in rewriters() {
            sourceFile = rewriter.rewrite(sourceFile)
        }
        return sourceFile.description
    }

    private func rewriters() -> [SyntaxRewriter] {
        [
            MainActorAdder(),
            AssemblyMigrator()
        ]
    }
}
