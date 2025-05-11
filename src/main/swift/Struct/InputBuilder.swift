//
//  InputBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public struct InputBuilder {
    
    let type: InputEnum
    let string: String
    
    public init(_ t: InputEnum, _ s: String) {
        self.type = t
        self.string = s
    }
    
    public var canon: String {
        self.string.canonicalized
    }
    
    public var trim: String {
        self.string.trimmed
    }
    
}
