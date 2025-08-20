//
//  MyTestingFIle.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/20/25.
//

import Foundation

public protocol TagsSortedSetProtocol: Stable, Quantifiable, RandomAccessCollection where Element: Hashable & Comparable, Index == Elements.Index {
    
    typealias Elements = SortedSet<Element>
    typealias Arr = [TagBuilder]
    
    var elements: Elements { get }
    var arr: Arr { get }
    
    static func -->(lhs: inout Self, rhs: Elements) -> Void
    
}

public extension TagsSortedSetProtocol {
        
    var builders: TagBuilders { .init(arr) }
    var quantity: Int { elements.count }
    var startIndex: Index { elements.startIndex }
    var endIndex: Index { elements.endIndex }
    
    subscript(index: Index) -> Element {
        get { elements[index] }
    }
    
    func index(after i: Index) -> Index {
        elements.index(after: i)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(elements)
    }
    
    static func += (lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.elements + rhs)
    }
    
    static func -= (lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.elements - rhs)
    }
    
    static func + (lhs: inout Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    static func - (lhs: inout Self, rhs: Element) -> Self {
        var new: Self = lhs
        new -= rhs
        return new
    }
    
}


public struct StringBuilderTags: TagsSortedSetProtocol {
    
    public typealias Element = StringBuilder
    public typealias Index = Elements.Index
    
    public static func -->(lhs: inout Self, rhs: Elements) -> Void { lhs.elements = rhs }
    
    public private(set) var elements: Elements
    
    public let input: InputEnum
    
    public init(_ i: InputEnum, _ e: Elements = .defaultValue) {
        self.elements = e
        self.input = i
    }
    
    public var arr: Arr { self.elements.map { .input(input, $0) } }

}

public struct ModeTags: TagsSortedSetProtocol {
    
    public typealias Element = ModeEnum
    public typealias Index = Elements.Index
    
    public static func -->(lhs: inout Self, rhs: Elements) -> Void { lhs.elements = rhs }
    
    public private(set) var elements: Elements
        
    public init(_ e: Elements = .defaultValue) {
        self.elements = e
    }
    
    public var arr: Arr { self.elements.map { .mode($0) } }

}

public struct FormatBuilderTags: TagsSortedSetProtocol {
    
    public typealias Element = FormatBuilder
    public typealias Index = Elements.Index
    public typealias Key = (SystemBuilder, FormatEnum)
    
    public static func -->(lhs: inout Self, rhs: Elements) -> Void { lhs.elements = rhs }
    
    public private(set) var elements: Elements
    
    private let key: Key
    
    public init(_ s: SystemBuilder, _ f: FormatEnum, _ e: Elements = .defaultValue) {
        self.elements = e
        self.key = (s, f)
    }
    
    public init(_ k: Key, _ e: Elements = .defaultValue) {
        self.init(k.0, k.1, e)
    }
    
    public var arr: Arr { self.elements.map { .platform(system, $0) } }
    
    public var system: SystemBuilder { self.key.0 }
    public var format: FormatEnum { self.key.1 }

}
