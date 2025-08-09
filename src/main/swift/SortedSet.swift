//
//  SortedSet.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/4/25.
//

import Foundation

public protocol SortedSetProtocol: Defaultable, Hashable, Quantifiable, RandomAccessCollection where Element: Hashable & Comparable {
    var isEmpty: Bool { get }
    var count: Int { get }
    
    func contains(_ element: Element) -> Bool
    
    init()

}

public struct SortedSet<Element: Hashable & Comparable>: SortedSetProtocol {
    
    private var set: ElementSet
    private var array: ElementArray
    
    public init() {
        self.init(.defaultValue, .defaultValue)
    }
    
    public init(_ collection: ElementCollection) {
        let set: ElementSet = .init(collection)
        let array: ElementArray = collection.sorted()
        self.init(set, array)
    }
    
    public init(_ elements: Element...) {
        let set: ElementSet = .init(elements)
        let array: ElementArray = elements.sorted()
        self.init(set, array)
    }
    
    private init(_ set: ElementSet, _ array: ElementArray) {
        self.set = set
        self.array = array
    }
    
}

public extension SortedSet {
    
    typealias ElementCollection = any Collection<Element>
    typealias ElementArray = [Element]
    typealias ElementSet = Set<Element>
    typealias Index = ElementArray.Index
    
    static func +=(lhs: inout Self, rhs: Self) -> Void {
        rhs.forEach { lhs += $0 }
    }
    
    static func -=(lhs: inout Self, rhs: Self) -> Void {
        rhs.forEach { lhs -= $0 }
    }

    static func +=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.set + rhs)
    }
    
    static func -=(lhs: inout Self, rhs: Element) -> Void {
        lhs --> (lhs.set - rhs)
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
    
    subscript(index: Index) -> Element {
        get { return array[index] }
    }
    
    var startIndex: Index {
        array.startIndex
    }
    
    var endIndex: Index {
        array.endIndex
    }
    
    func index(after i: Index) -> Index {
        array.index(after: i)
    }
    
//    mutating func remove(_ index: Index) {
//        self.mutate(self[index], .remove)
//    }
//    
//    mutating func remove(_ element: Element) -> Void {
//        self.mutate(element, .remove)
//    }
//    
//    mutating func insert(_ element: Element) -> Void {
//        self.mutate(element, .insert)
//    }
    
}

fileprivate extension SortedSet {
    
    static func -->(lhs: inout Self, rhs: ElementSet) -> Void {
        lhs.set = rhs
        lhs.array = rhs.sorted()
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
    
//    enum Action: Enumerable {
//        case insert, remove
//    }
//    
//    mutating func mutate(_ element: Element, _ action: Action) -> Void {
//        switch action {
//        case .insert:
//            self.set.insert(element)
//        case .remove:
//            self.set.remove(element)
//        }
//        self.array = self.set.sorted()
//    }
    
}

extension SortedSet: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue < rhs.hashValue
    }
    
}

extension SortedSet: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.array)
    }
    
}

extension SortedSet: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

extension SortedSet: Quantifiable {
    
    public var quantity: Int {
        self.array.count
    }
    
}

//

extension SortedSet where Element: Valuable {
    
    public var joined: String {
        self.map { $0.rawValue }.joined(separator: ", ")
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
    
//    public static func +(lhs: Self, rhs: Element) -> Self {
//        var new: Self = lhs
//        new.insert(rhs)
//        return new
//    }
//    
//    public static func -(lhs: Self, rhs: Element) -> Self {
//        var new: Self = lhs
//        new.remove(rhs)
//        return new
//    }
//
    
    public static func random(_ range: Range<Int>) -> Self {
        Self.random(range) {
            .string(.random)
        }
    }
    
//    public func tags(_ input: InputEnum) -> [TagBuilder] {
//        self.map { InputBuilder(input, $0.trim) }.map(TagBuilder.input)
//    }
//    
//    public var array: [String] {
//        self.map { $0.trim }.sorted()
//    }
//    
//    public var string: String {
//        self.array.joined(separator: ", ")
//    }
    
}
