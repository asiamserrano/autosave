//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

extension Dictionary: Quantifiable {
    
    public var quantity: Int { self.count }
    
}

extension Dictionary where Value: Universable {
    
    public static func -->(lhs: inout Self, rhs: (Value?, Key)) -> Void {
        let value: Value = rhs.0 ?? .defaultValue
        lhs[rhs.1] = value.isVacant ? nil : value
    }
    
    public static func -->(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new --> (rhs.value, rhs.key)
        return new
    }
    
}
