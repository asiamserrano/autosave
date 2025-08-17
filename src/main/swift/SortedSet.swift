//
//  SortedSet.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/4/25.
//

import Foundation

public struct SortedSet<Element: Hashable & Comparable>: SortedSetProtocol {
    
    public typealias List = [Element]
    public typealias Index = List.Index
    
    public private(set) var set: Group
    public private(set) var list: List

    public init(_ set: Group, _ list: List) {
        self.set = set
        self.list = list
    }
    
}

public extension SortedSet {
    
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
