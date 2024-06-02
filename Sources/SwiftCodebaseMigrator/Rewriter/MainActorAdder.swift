//
//  MainActorAdder.swift
//  
//
//  Created by Alexandre Podlewski on 01/06/2024.
//

import Foundation
import SwiftParser
import SwiftSyntax

final class MainActorAdder: SyntaxRewriter {

    override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        var node = node
        if shouldAddMainActorToProtocol(withName: node.name.text) {
            node.addMainActorAttributeIfMissing()
        }
        return DeclSyntax(node)
    }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        var node = node
        if shouldAddMainActorToClass(withName: node.name.text) {
            node.addMainActorAttributeIfMissing()
        }
        return DeclSyntax(node)
    }

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        var node = node
        if shouldAddMainActorToStruct(withName: node.name.text) {
            node.addMainActorAttributeIfMissing()
        }
        return DeclSyntax(node)
    }

    // MARK: - Private

    private static let concernedProtocolSuffixes = [
        "Presenter",
        "PresenterDelegate",
        "ViewContract",
        "CoordinatorDelegate",
        "ViewDelegate",
        "ViewCellDelegate"
    ]
    private static let concernedClassSuffixes = [
        "Coordinator",
        "ViewModelMapper"
    ] // ["PresenterImplementation", "Coordinator"]
    private static let concernedStructSuffixes = ["ViewModelMapper"] // "ViewModel" ?

    private func shouldAddMainActorToProtocol(withName name: String) -> Bool {
        return Self.concernedProtocolSuffixes.contains { name.hasSuffix($0) }
    }

    private func shouldAddMainActorToClass(withName name: String) -> Bool {
        return Self.concernedClassSuffixes.contains { name.hasSuffix($0) }
    }

    private func shouldAddMainActorToStruct(withName name: String) -> Bool {
        return Self.concernedStructSuffixes.contains { name.hasSuffix($0) }
    }
}

private extension ProtocolDeclSyntax {
    @discardableResult
    mutating func addMainActorAttributeIfMissing() -> Self {
        guard !attributes.containsMainActorAttribute else { return self }
        let leadingTrivia: Trivia
        if !modifiers.leadingTrivia.isEmpty {
            leadingTrivia = modifiers.leadingTrivia
            modifiers.leadingTrivia = []
        } else if !protocolKeyword.leadingTrivia.isEmpty {
            leadingTrivia = protocolKeyword.leadingTrivia
            protocolKeyword.leadingTrivia = []
        } else {
            leadingTrivia = []
        }
        attributes.append(.attribute(
            AttributeSyntax(
                leadingTrivia: leadingTrivia,
                attributeName: IdentifierTypeSyntax(name: .identifier("MainActor")),
                trailingTrivia: .newline
            )
        ))
        return self
    }
}

private extension ClassDeclSyntax {
    @discardableResult
    mutating func addMainActorAttributeIfMissing() -> Self {
        guard !attributes.containsMainActorAttribute else { return self }
        let leadingTrivia: Trivia
        if !modifiers.leadingTrivia.isEmpty {
            leadingTrivia = modifiers.leadingTrivia
            modifiers.leadingTrivia = []
        } else if !classKeyword.leadingTrivia.isEmpty {
            leadingTrivia = classKeyword.leadingTrivia
            classKeyword.leadingTrivia = []
        } else {
            leadingTrivia = []
        }
        attributes.append(.attribute(
            AttributeSyntax(
                leadingTrivia: leadingTrivia,
                attributeName: IdentifierTypeSyntax(name: .identifier("MainActor")),
                trailingTrivia: .newline
            )
        ))
        return self
    }
}

private extension StructDeclSyntax {
    @discardableResult
    mutating func addMainActorAttributeIfMissing() -> Self {
        guard !attributes.containsMainActorAttribute else { return self }
        let leadingTrivia: Trivia
        if !modifiers.leadingTrivia.isEmpty {
            leadingTrivia = modifiers.leadingTrivia
            modifiers.leadingTrivia = []
        } else if !structKeyword.leadingTrivia.isEmpty {
            leadingTrivia = structKeyword.leadingTrivia
            structKeyword.leadingTrivia = []
        } else {
            leadingTrivia = []
        }
        attributes.append(.attribute(
            AttributeSyntax(
                leadingTrivia: leadingTrivia,
                attributeName: IdentifierTypeSyntax(name: .identifier("MainActor")),
                trailingTrivia: .newline
            )
        ))
        return self
    }
}
