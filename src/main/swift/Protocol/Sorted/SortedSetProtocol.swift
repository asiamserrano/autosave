//
//  SortedSetProtocol.swift
//  autosave
//
//  Created by Asia Serrano on 8/10/25.
//

import Foundation

public protocol SortedSetProtocol: Defaultable, Hashable, Quantifiable, RandomAccessCollection where Element: Hashable & Comparable, Index == List.Index {
    
    typealias Party = any Collection<Element>
    typealias Group = Set<Element>
    typealias List = [Element]
    
    var set: Group { get }
    var list: List { get }
    
    func contains(_ element: Element) -> Bool
    
    init(_ g: Group, _ l: List)
    
    static func -->(lhs: inout Self, rhs: Group) -> Void
    
}

public extension SortedSetProtocol {
    
    var quantity: Int {
        self.list.count
    }
    
    var startIndex: Index {
        list.startIndex
    }
    
    var endIndex: Index {
        list.endIndex
    }
    
    subscript(index: Index) -> Element {
        get { return list[index] }
    }
    
    func index(after i: Index) -> Index {
        list.index(after: i)
    }
    
    func hash(into hasher: inout Hasher) {
        self.list.forEach { hasher.combine($0) }
    }
    
}

// INIT

public extension SortedSetProtocol {
    
    init() {
        self.init(.defaultValue, .defaultValue)
    }
    
    init(_ party: Party) {
        let set: Group = .init(party)
        let list: List = party.sorted()
        self.init(set, list)
    }
    
    init(_ elements: Element...) {
        let set: Group = .init(elements)
        let list: List = elements.sorted()
        self.init(set, list)
    }
    
}

// STATIC

public extension SortedSetProtocol {
    
    static var defaultValue: Self { .init() }
    
    static func -=(lhs: inout Self, rhs: Index) -> Void {
        lhs -= lhs.list[rhs]
    }
    
    static func +=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.set + rhs)
    }
    
    static func -=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.set - rhs)
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
    
    static func +(lhs: Self, rhs: Self) -> Self {
        let group: Group = lhs.set.union(rhs.set)
        return .init(group)
    }

    static func -(lhs: Self, rhs: Self) -> Self {
        let group: Group = lhs.set.subtracting(rhs.set)
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
