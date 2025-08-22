//
//  Modes.swift
//  autosave
//
//  Created by Asia Serrano on 8/15/25.
//

import Foundation

public struct Modes: TagsProtocol {
    
    public typealias Element = ModeEnum
    public typealias Elements = SortedSet<Element>
    public typealias Index = Elements.Index
    
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements += rhs
        lhs.builders += .mode(rhs)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements -= rhs
        lhs.builders -= .mode(rhs)
    }
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    public private(set) var elements: Elements
    public private(set) var builders: TagBuilders
        
    public init(_ e: Elements) {
        self.elements = e
        self.builders = .init(e.map { .mode($0)})
    }
    
    public init() {
        self.elements = .defaultValue
        self.builders = .defaultValue
    }
    
    public subscript(index: Index) -> Element {
        get { elements[index] }
    }

}
