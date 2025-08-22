//
//  MyTestingFIle.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/20/25.
//

import Foundation

// TempProtocol
public protocol TempProtocol: Defaultable, Stable, Quantifiable {
    
    associatedtype Element: Hashable & Comparable

    static func +=(lhs: inout Self, rhs: Element) -> Void
    static func -=(lhs: inout Self, rhs: Element) -> Void
    
    var builders: TagBuilders { get }
    
    init()
}

extension TempProtocol {
    
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

    public static var defaultValue: Self { .init() }
    
    public var quantity: Int { builders.count }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(builders)
    }
    
}

public struct Modes: TempProtocol {
    
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
