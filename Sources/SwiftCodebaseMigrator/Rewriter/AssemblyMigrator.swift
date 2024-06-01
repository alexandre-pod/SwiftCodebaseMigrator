//
//  AssemblyMigrator.swift
//
//
//  Created by Alexandre Podlewski on 01/06/2024.
//

import Foundation
import SwiftSyntax

final class AssemblyMigrator: SyntaxRewriter {

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard let inheritanceClause = node.inheritanceClause,
              inheritanceClause.inheritedTypes.contains(
                where: { $0.type.as(IdentifierTypeSyntax.self)?.name.text == "Assembly" }
              )
        else { return DeclSyntax(node) }

        return super.visit(node)

    }

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        var node = node

        guard let accessExpression = node.calledExpression.as(MemberAccessExprSyntax.self),
              accessExpression.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "container",
              accessExpression.declName.baseName.text == "register"
        else {
            return super.visit(node)
        }

        node.trailingClosure?.signature?.addMainActorAttributeIfMissing()

        return ExprSyntax(node)
    }
}

private extension ClosureSignatureSyntax {
    @discardableResult
    mutating func addMainActorAttributeIfMissing() -> Self {
        guard !attributes.containsMainActorAttribute else { return self }
        let leadingTrivia: Trivia
        if let capture, !capture.leadingTrivia.isEmpty {
            leadingTrivia = capture.leadingTrivia
            self.capture?.leadingTrivia = []
        } else if let parameterClause, !parameterClause.leadingTrivia.isEmpty {
            leadingTrivia = parameterClause.leadingTrivia
            self.parameterClause?.leadingTrivia = []
        } else {
            leadingTrivia = []
        }
        attributes.append(.attribute(
            AttributeSyntax(
                leadingTrivia: leadingTrivia,
                attributeName: IdentifierTypeSyntax(name: .identifier("MainActor")),
                trailingTrivia: .space
            )
        ))
        return self
    }
}
