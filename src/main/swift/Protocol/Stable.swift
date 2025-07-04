//
//  Stable.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import Foundation

public protocol Stable: Hashable {}

extension Stable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
