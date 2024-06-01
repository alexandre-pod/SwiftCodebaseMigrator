//
//  TerminalHelper.swift
//  
//
//  Created by Alexandre Podlewski on 02/06/2024.
//

import Foundation

enum TerminalHelper {
    static let eraseLineFromCursor = "\u{001B}[0K"
}

func printOnCurrentLine(_ text: String) {
    print("\r\(TerminalHelper.eraseLineFromCursor)\(text)", terminator: "")
}
