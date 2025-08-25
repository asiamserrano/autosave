//
//  TagsProtocol.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public protocol TagsProtocol: Universable {
    
    associatedtype Element: Hashable & Comparable

    static func +=(lhs: inout Self, rhs: Element) -> Void
    static func -=(lhs: inout Self, rhs: Element) -> Void
    
    var builders: TagBuilders { get }
    
    init()
}

extension TagsProtocol {
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new -= rhs
        return new
    }

    public static var defaultValue: Self { .init() }
    
    public var quantity: Int { builders.count }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(builders)
    }
    
}
