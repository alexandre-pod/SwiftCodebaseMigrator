//
//  SendableInserter.swift
//  
//
//  Created by Alexandre Podlewski on 02/06/2024.
//

import Foundation
import SwiftParser
import SwiftSyntax

final class SendableInserter: SyntaxRewriter {

    override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        var node = node
        if shouldAddSendableToProtocol(withName: node.name.text) {
            node.addSendableIfMissing()
        }
        return DeclSyntax(node)
    }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        var node = node
        if shouldAddSendableToClass(withName: node.name.text) {
            node.addSendableIfMissing()
        }
        return DeclSyntax(node)
    }

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        var node = node
        if shouldAddSendableToStruct(withName: node.name.text) {
            node.addSendableIfMissing()
        }
        return DeclSyntax(node)
    }

    // MARK: - Private

    private static let concernedProtocolSuffixes: [String] = ["Repository"]
    private static let concernedClassSuffixes: [String] = []
    private static let concernedStructSuffixes: [String] = []

    private func shouldAddSendableToProtocol(withName name: String) -> Bool {
        return Self.concernedProtocolSuffixes.contains { name.hasSuffix($0) }
    }

    private func shouldAddSendableToClass(withName name: String) -> Bool {
        return Self.concernedClassSuffixes.contains { name.hasSuffix($0) }
    }

    private func shouldAddSendableToStruct(withName name: String) -> Bool {
        return Self.concernedStructSuffixes.contains { name.hasSuffix($0) }
    }
}

private extension ProtocolDeclSyntax {
    @discardableResult
    mutating func addSendableIfMissing() -> Self {
        self.addInheritanceClauseIfMissing()
        guard !inheritanceClause!.containsSendable else { return self }

        let trailingTrivia: Trivia
        if !inheritanceClause!.trailingTrivia.isEmpty {
            trailingTrivia = inheritanceClause!.trailingTrivia
            inheritanceClause!.trailingTrivia = []
        } else if let lastInheritedTypes = inheritanceClause!.inheritedTypes.last, !lastInheritedTypes.trailingTrivia.isEmpty {
            trailingTrivia = lastInheritedTypes.trailingTrivia
            inheritanceClause!.inheritedTypes[inheritanceClause!.inheritedTypes.indices.last!].trailingTrivia = []
        } else {
            trailingTrivia = []
        }

        inheritanceClause!.inheritedTypes.append(
            InheritedTypeSyntax(
                type: IdentifierTypeSyntax(name: .identifier("Sendable")),
                trailingTrivia: trailingTrivia
            )
        )
        if inheritanceClause!.colon.trailingTrivia.isEmpty {
            inheritanceClause!.colon.trailingTrivia = .space
        }
        return self
    }

    mutating func addInheritanceClauseIfMissing() {
        guard inheritanceClause == nil else { return }

        let trailingTrivia: Trivia
        if !name.trailingTrivia.isEmpty {
            trailingTrivia = name.trailingTrivia
            name.trailingTrivia = []
        } else if let primaryAssociatedTypeClause, !primaryAssociatedTypeClause.trailingTrivia.isEmpty {
            trailingTrivia = primaryAssociatedTypeClause.trailingTrivia
            self.primaryAssociatedTypeClause?.trailingTrivia = []
        } else {
            trailingTrivia = []
        }
        inheritanceClause = InheritanceClauseSyntax(
            inheritedTypes: InheritedTypeListSyntax([]),
            trailingTrivia: trailingTrivia
        )
    }
}

private extension ClassDeclSyntax {
    @discardableResult
    mutating func addSendableIfMissing() -> Self {
        self.addInheritanceClauseIfMissing()
        guard !inheritanceClause!.containsSendable else { return self }

        let trailingTrivia: Trivia
        if !inheritanceClause!.trailingTrivia.isEmpty {
            trailingTrivia = inheritanceClause!.trailingTrivia
            inheritanceClause!.trailingTrivia = []
        } else if let lastInheritedTypes = inheritanceClause!.inheritedTypes.last, !lastInheritedTypes.trailingTrivia.isEmpty {
            trailingTrivia = lastInheritedTypes.trailingTrivia
            inheritanceClause!.inheritedTypes[inheritanceClause!.inheritedTypes.indices.last!].trailingTrivia = []
        } else {
            trailingTrivia = []
        }

        inheritanceClause!.inheritedTypes.append(
            InheritedTypeSyntax(
                type: IdentifierTypeSyntax(name: .identifier("Sendable")),
                trailingTrivia: trailingTrivia
            )
        )
        if inheritanceClause!.colon.trailingTrivia.isEmpty {
            inheritanceClause!.colon.trailingTrivia = .space
        }
        return self
    }

    mutating func addInheritanceClauseIfMissing() {
        guard inheritanceClause == nil else { return }

        let trailingTrivia: Trivia
        if !name.trailingTrivia.isEmpty {
            trailingTrivia = name.trailingTrivia
            name.trailingTrivia = []
        } else if let genericParameterClause, !genericParameterClause.trailingTrivia.isEmpty {
            trailingTrivia = genericParameterClause.trailingTrivia
            self.genericParameterClause?.trailingTrivia = []
        } else {
            trailingTrivia = []
        }
        inheritanceClause = InheritanceClauseSyntax(
            inheritedTypes: InheritedTypeListSyntax([]),
            trailingTrivia: trailingTrivia
        )
    }
}

private extension StructDeclSyntax {
    @discardableResult
    mutating func addSendableIfMissing() -> Self {
        self.addInheritanceClauseIfMissing()
        guard !inheritanceClause!.containsSendable else { return self }

        let trailingTrivia: Trivia
        if !inheritanceClause!.trailingTrivia.isEmpty {
            trailingTrivia = inheritanceClause!.trailingTrivia
            inheritanceClause!.trailingTrivia = []
        } else if let lastInheritedTypes = inheritanceClause!.inheritedTypes.last, !lastInheritedTypes.trailingTrivia.isEmpty {
            trailingTrivia = lastInheritedTypes.trailingTrivia
            inheritanceClause!.inheritedTypes[inheritanceClause!.inheritedTypes.indices.last!].trailingTrivia = []
        } else {
            trailingTrivia = []
        }

        inheritanceClause!.inheritedTypes.append(
            InheritedTypeSyntax(
                type: IdentifierTypeSyntax(name: .identifier("Sendable")),
                trailingTrivia: trailingTrivia
            )
        )
        if inheritanceClause!.colon.trailingTrivia.isEmpty {
            inheritanceClause!.colon.trailingTrivia = .space
        }
        return self
    }

    mutating func addInheritanceClauseIfMissing() {
        guard inheritanceClause == nil else { return }

        let trailingTrivia: Trivia
        if !name.trailingTrivia.isEmpty {
            trailingTrivia = name.trailingTrivia
            name.trailingTrivia = []
        } else if let genericParameterClause, !genericParameterClause.trailingTrivia.isEmpty {
            trailingTrivia = genericParameterClause.trailingTrivia
            self.genericParameterClause?.trailingTrivia = []
        } else {
            trailingTrivia = []
        }
        inheritanceClause = InheritanceClauseSyntax(
            inheritedTypes: InheritedTypeListSyntax([]),
            trailingTrivia: trailingTrivia
        )
    }
}
