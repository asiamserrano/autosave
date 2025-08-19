//
//  SortedSet.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/4/25.
//

import Foundation

public struct SortedSet<Element: Hashable & Comparable>: SortedSetProtocol {
    
    public typealias Ordered = [Element]
    public typealias Index = Ordered.Index
    
    public private(set) var unordered: Unordered
    public private(set) var ordered: Ordered

    public init(_ u: Unordered, _ o: Ordered) {
        self.unordered = u
        self.ordered = o
    }
        
}

public extension SortedSet {
    
    static func -->(lhs: inout Self, rhs: Unordered) -> Void {
        lhs.unordered = rhs
        lhs.ordered = rhs.sorted()
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
    
    public func toBuilders(_ input: InputEnum) -> TagBuilders {
        let inputs: [InputBuilder] = self.map { .init(input, $0) }
        let tags: [TagBuilder] = inputs.map { .input($0) }
        return .init(tags)
    }
    
}

extension SortedSet where Element == ModeEnum {
    
    public var toBuilders: TagBuilders {
        let tags: [TagBuilder] = self.map { .mode($0) }
        return .init(tags)
    }
    
}
