//
//  StringBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public struct StringBuilder: Hashable {
        
    public static func enumeror(_ enumeror: Enumeror) -> Self {
        let canon: String = enumeror.id
        let trim: String = enumeror.rawValue
        return .init(canon, trim)
    }
    
    public static func string(_ string: String) -> Self {
        let canon: String = string.canonicalized
        let trim: String = string.trimmed
        return .init(canon, trim)
    }
    
    public let canon: String
    public let trim: String
    
    private init(_ c: String, _ t: String) {
        self.canon = c
        self.trim = t
    }
    
}

extension StringBuilder: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.canon == rhs.canon {
            return lhs.trim < rhs.trim
        } else {
            return lhs.canon < rhs.canon
        }
    }
    
}

extension StringBuilder: Valuable {
    
    public var rawValue: String { self.trim }
    
}
