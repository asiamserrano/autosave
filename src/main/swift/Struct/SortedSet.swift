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
    
    func lacks(_ element: Element) -> Bool {
        !self.contains(element)
    }
    
}

extension SortedSet where Element: Randomizable {
            
    public static func random(_ range: Range<Int>) -> Self {
        let size: Int = Int.random(in: range)
        var new: Self = .init()
        
        while new.count < size {
            let element: Element = .random
            new += element
        }
        
        return new
    }
    
    public static var random: Self {
        .random(1..<3)
    }
    
}
