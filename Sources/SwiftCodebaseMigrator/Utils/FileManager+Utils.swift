//
//  FileManager+Utils.swift
//
//
//  Created by Alexandre Podlewski on 02/06/2024.
//

import Foundation

extension FileManager {

    func getFiles(withSuffix suffix: String, inDirectory path: URL) -> [URL] {
        let resourceKeys = Set<URLResourceKey>([.nameKey])
        let directoryEnumerator = FileManager.default.enumerator(
            at: path,
            includingPropertiesForKeys: Array(resourceKeys),
            options: [.skipsHiddenFiles, .skipsPackageDescendants],
            errorHandler: nil
        )!

        var fileURLs: [URL] = []
        for case let fileURL as URL in directoryEnumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                  let name = resourceValues.name
            else { continue }

            if name.hasSuffix(suffix) {
                fileURLs.append(fileURL)
            }
        }
        return fileURLs
    }
}
