//
//  RelationType.swift
//  autosave
//
//  Created by Asia Serrano on 7/14/25.
//

import Foundation

public enum RelationType: Encapsulable {
    
    public static var allCases: Cases {
        RelationCategory.allCases.flatMap { type in
            switch type {
            case .property:
                return PropertyType.cases.map(Self.property)
            case .tag:
                return TagType.cases.map(Self.tag)
            }
        }
    }
    
    case property(PropertyType)
    case tag(TagType)
    
    public var enumeror: Enumeror {
        switch self {
        case .property(let p):
            return p
        case .tag(let t):
            return t
        }
    }
    
    public var category: RelationCategory {
        switch self {
        case .property:
            return .property
        case .tag:
            return .tag
        }
    }
    
}
