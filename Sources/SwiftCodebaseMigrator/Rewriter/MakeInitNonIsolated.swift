//
//  MakeInitNonIsolated.swift
//
//
//  Created by Alexandre Podlewski on 01/06/2024.
//

import Foundation
import SwiftParser
import SwiftSyntax

final class MakeInitNonIsolated: SyntaxRewriter {

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        var node = node
        if shouldAddMainActorToClass(withName: node.name.text) {
            node.addNonIsolatedMarkerToInitializers()
        }
        return DeclSyntax(node)
    }

    // MARK: - Private

    private static let concernedClassSuffixes: [String] = [
        "PresenterImplementation"
    ]

    private func shouldAddMainActorToClass(withName name: String) -> Bool {
        return Self.concernedClassSuffixes.contains { name.hasSuffix($0) }
    }
}

private extension ClassDeclSyntax {
    @discardableResult
    mutating func addNonIsolatedMarkerToInitializers() -> Self {
        for (index, member) in zip(memberBlock.members.indices, memberBlock.members) {
            guard var initializerDecl = member.decl.as(InitializerDeclSyntax.self),
                  !initializerDecl.modifiers.containsNonIsolated
            else { continue }

            let leadingTrivia: Trivia
            if !initializerDecl.modifiers.leadingTrivia.isEmpty {
                leadingTrivia = initializerDecl.modifiers.leadingTrivia
                initializerDecl.modifiers.leadingTrivia = []
            } else if !initializerDecl.initKeyword.leadingTrivia.isEmpty {
                leadingTrivia = initializerDecl.initKeyword.leadingTrivia
                initializerDecl.initKeyword.leadingTrivia = []
            } else {
                leadingTrivia = []
            }


            initializerDecl.modifiers.append(DeclModifierSyntax(
                leadingTrivia: leadingTrivia, 
                name: .keyword(.nonisolated),
                trailingTrivia: .space
            ))
            memberBlock.members[index] =  MemberBlockItemSyntax(decl: initializerDecl)
        }
        return self
    }
}

private extension DeclModifierListSyntax {
    var containsNonIsolated: Bool {
        return contains { $0.name.text == "nonisolated" }
    }
}
