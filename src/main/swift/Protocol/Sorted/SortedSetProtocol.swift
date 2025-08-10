//
//  SortedSetProtocol.swift
//  autosave
//
//  Created by Asia Serrano on 8/10/25.
//

import Foundation

public protocol SortedSetProtocol: Defaultable, Hashable, Quantifiable, RandomAccessCollection where Element: Hashable & Comparable, Index == List.Index {
    
    associatedtype List: RandomAccessCollection where List.Element == Element
    
    // ✅ existential Collection of *this* protocol’s Element
     typealias Party = any Collection<Element>
    
    var list: List { get }
    
    func contains(_ element: Element) -> Bool
    
    init()
    init(_ elements: Element...)
    init(_ party: Party)   // uses the existential above

    static func +=(lhs: inout Self, rhs: Element) -> Void
    static func -=(lhs: inout Self, rhs: Element) -> Void

}

extension SortedSetProtocol {
    
    public subscript(index: Index) -> Element {
        get { return list[index] }
    }
    
    public var startIndex: Index {
        list.startIndex
    }
    
    public var endIndex: Index {
        list.endIndex
    }
    
    public func index(after i: Index) -> Index {
        list.index(after: i)
    }
    
    public static func +=(lhs: inout Self, rhs: Self) -> Void {
        rhs.forEach { lhs += $0 }
    }
    
    public static func -=(lhs: inout Self, rhs: Self) -> Void {
        rhs.forEach { lhs -= $0 }
    }
    
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
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue < rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        self.list.forEach { hasher.combine($0) }
    }
    
    public static var defaultValue: Self { .init() }

    public var quantity: Int {
        self.list.count
    }
    
}

extension SortedSetProtocol where Element: Valuable {
    
    public var joined: String {
        self.map { $0.rawValue }.joined(separator: ", ")
    }
    
}
