//
//  SortedSetProtocol.swift
//  autosave
//
//  Created by Asia Serrano on 8/10/25.
//

import Foundation

public protocol SortedSetProtocol: Defaultable, Hashable, Quantifiable, RandomAccessCollection where Element: Hashable & Comparable, Index == Ordered.Index {
    
    typealias Party = any Collection<Element>
    typealias Unordered = Set<Element>
    typealias Ordered = [Element]
    
    var unordered: Unordered { get }
    var ordered: Ordered { get }
    
    func contains(_ element: Element) -> Bool
    
    init(_ u: Unordered, _ o: Ordered)
    
    static func -->(lhs: inout Self, rhs: Unordered) -> Void
    
}

public extension SortedSetProtocol {
    
    var quantity: Int {
        self.ordered.count
    }
    
    var startIndex: Index {
        ordered.startIndex
    }
    
    var endIndex: Index {
        ordered.endIndex
    }
    
    subscript(index: Index) -> Element {
        get { return ordered[index] }
    }
    
    func index(after i: Index) -> Index {
        ordered.index(after: i)
    }
    
    func hash(into hasher: inout Hasher) {
        self.ordered.forEach { hasher.combine($0) }
    }
    
}

// INIT

public extension SortedSetProtocol {
    
    init() {
        self.init(.defaultValue, .defaultValue)
    }
    
    init(_ party: Party) {
        let unordered: Unordered = .init(party)
        let ordered: Ordered = party.sorted()
        self.init(unordered, ordered)
    }
    
    init(_ elements: Element...) {
        let unordered: Unordered = .init(elements)
        let ordered: Ordered = elements.sorted()
        self.init(unordered, ordered)
    }
    
}

// STATIC


public extension SortedSetProtocol {
    
    static var defaultValue: Self { .init() }
    
    static func -=(lhs: inout Self, rhs: Index) -> Void {
        lhs -= lhs.ordered[rhs]
    }
    
    static func +=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.unordered + rhs)
    }
    
    static func -=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.unordered - rhs)
    }
    
    static func +=(lhs: inout Self, rhs: Self) -> Void {
        rhs.forEach { lhs += $0 }
    }
    
    static func -=(lhs: inout Self, rhs: Self) -> Void {
        rhs.forEach { lhs -= $0 }
    }
    
    static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new -= rhs
        return new
    }
    
    static func -(lhs: Self, rhs: Index) -> Self {
        var new: Self = lhs
        new -= rhs
        return new
    }
    
    static func +(lhs: Self, rhs: Self) -> Self {
        let group: Unordered = lhs.unordered.union(rhs.unordered)
        return .init(group)
    }

    static func -(lhs: Self, rhs: Self) -> Self {
        let group: Unordered = lhs.unordered.subtracting(rhs.unordered)
        return .init(group)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue < rhs.hashValue
    }
    
}


extension SortedSetProtocol where Element: Valuable {
    
    public var joined: String {
        self.map { $0.rawValue }.joined(separator: ", ")
    }
    
}
