//
//  InputBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public struct InputBuilder {
    
    public static func random(_ input: InputEnum) -> Self {
        .init(input, .random)
    }
    
    public static var random: Self {
        .random(.random)
    }
    
    let type: InputEnum
    let string: String
    
    public init(_ t: InputEnum, _ s: StringBuilder) {
        self.init(t, s.trim)
    }
    
    public init(_ t: InputEnum, _ s: String) {
        self.type = t
        self.string = s.trimmed
    }
    
    public var stringBuilder: StringBuilder {
        .string(self.string)
    }
    
}

extension InputBuilder: Comparable {
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        if lhs.type == rhs.type {
            return lhs.stringBuilder < rhs.stringBuilder
        } else {
            return lhs.type < rhs.type
        }
    }
    
}

extension InputBuilder: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.stringBuilder)
    }
    
}
