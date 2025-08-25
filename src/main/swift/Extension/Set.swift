//
//  Set.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation

extension Set {
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        var new: Self = lhs
        rhs.forEach { new.insert($0) }
        return new
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        var new: Self = lhs
        rhs.forEach { new.remove($0) }
        return new
    }
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.insert(rhs)
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.remove(rhs)
        return new
    }
    
    public func lacks(_ element: Element) -> Bool {
        !self.contains(element)
    }
    
}

extension Set: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}
