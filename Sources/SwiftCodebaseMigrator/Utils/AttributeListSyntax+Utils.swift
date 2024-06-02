//
//  AttributeListSyntax+Utils.swift
//  
//
//  Created by Alexandre Podlewski on 02/06/2024.
//

import SwiftSyntax

extension AttributeListSyntax {
    var containsMainActorAttribute: Bool {
        return contains { element in
            switch element {
            case .attribute(let attribute):
                guard let identifier = attribute.attributeName.as(IdentifierTypeSyntax.self) else { return false }
                return identifier.name.text == "MainActor"
            case .ifConfigDecl:
                return false
            }
        }
    }
}
