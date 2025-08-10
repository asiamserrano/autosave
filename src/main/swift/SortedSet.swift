//
//  SortedSet.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/4/25.
//

import Foundation

public struct SortedSet<Element: Hashable & Comparable>: SortedSetProtocol {
    
    private var set: Group
    public private(set) var list: List
    
    public init() {
        self.init(.defaultValue, .defaultValue)
    }
    
    public init(_ party: Party) {
        let set: Group = .init(party)
        let list: List = party.sorted()
        self.init(set, list)
    }
    
    public init(_ elements: Element...) {
        let set: Group = .init(elements)
        let list: List = elements.sorted()
        self.init(set, list)
    }
    
    private init(_ set: Group, _ list: List) {
        self.set = set
        self.list = list
    }
    
}

public extension SortedSet {
            
//    typealias Party = any Collection<Element>
    typealias List = [Element]
    typealias Group = Set<Element>
    typealias Index = List.Index

    static func +=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.set + rhs)
    }
    
    static func -=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.set - rhs)
    }
    
}

fileprivate extension SortedSet {
    
    static func -->(lhs: inout Self, rhs: Group) -> Void {
        lhs.set = rhs
        lhs.list = rhs.sorted()
    }
    
}

private extension SortedSet {
        
    static func random(_ range: Range<Int>, method: @escaping () -> Element) -> Self {
        let size: Int = Int.random(in: range)
        
        var new: Self = .init()
        
        while new.count < size {
            new += method()
        }
        
        return new
    }
    
}

extension SortedSet where Element == SystemBuilder {
    
    public static func random(_ range: Range<Int>) -> Self {
        Self.random(range) {
            .random
        }
    }
    
}

extension SortedSet where Element == StringBuilder {
    
    public static func random(_ range: Range<Int>) -> Self {
        Self.random(range) {
            .string(.random)
        }
    }
    
    public var strings: SortedSet<String> {
        .init(self.map { $0.trim })
    }
    
}
