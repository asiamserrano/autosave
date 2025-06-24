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
    
    public init(_ t: InputEnum, _ s: String) {
        self.type = t
        self.string = s.trimmed
    }
    
    public var stringBuilder: StringBuilder {
        .string(self.string)
    }
    
//    public var canon: String {
//        self.string.canonicalized
//    }
//    
//    public var trim: String {
//        self.string.trimmed
//    }
    
}
