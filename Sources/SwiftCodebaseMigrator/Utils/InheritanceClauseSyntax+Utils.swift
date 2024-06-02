//
//  InheritanceClauseSyntax+Utils.swift
//  
//
//  Created by Alexandre Podlewski on 02/06/2024.
//

import Foundation
import SwiftSyntax

extension InheritanceClauseSyntax {
    var containsSendable: Bool {
        self.inheritedTypes.contains { element in
            guard let identifier = element.type.as(IdentifierTypeSyntax.self) else {
                return false
            }
            return identifier.name.text == "Sendable"
        }
    }
}
