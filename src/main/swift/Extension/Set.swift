//
//  Set.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation

extension Set {
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        var new: Self = lhs
        rhs.forEach { new.remove($0) }
        return new
    }
    
    public func lacks(_ element: Element) -> Bool {
        !self.contains(element)
    }
    
}

extension Set: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
    public init(_ element: Element) {
        self = [element]
    }
    
    mutating func delete(_ element: Element) -> Void {
        self = self.filter(element)
    }
    
    func filter(_ element: Element) -> Self {
        self.filter { $0 != element }
    }
    
}

extension Set where Element == StringBuilder {
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.insert(rhs)
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.remove(rhs)
        return new
    }
    
    public static func random(_ range: Range<Int>) -> Self {
        let size: Int = Int.random(in: range)
        
        var set: Self = []
        while set.count < size {
            let element: Element = .string(.random)
            set.insert(element)
        }
        return set
    }
    
    public func tags(_ input: InputEnum) -> [TagBuilder] {
        self.map { InputBuilder(input, $0.trim) }.map(TagBuilder.input)
    }
    
    public var array: [String] {
        self.map { $0.trim }.sorted()
    }
    
    public var string: String {
        self.array.joined(separator: ", ")
    }
    
}

extension Set where Element == FormatBuilder {
    
    public func tags(_ system: SystemBuilder) -> [TagBuilder] {
        self.map { PlatformBuilder(system, $0) }.map(TagBuilder.platform)
    }
    
    static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.insert(rhs)
        return new
    }
    
    static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.remove(rhs)
        return new
    }
    
    
//    @discardableResult
//    @inlinable public mutating func remove(_ element: FormatEnum) -> [Element] {
//        self.filter { $0.type != element }.compactMap { self.remove($0) }
//    }
    
//    @discardableResult
//    @inlinable public mutating func remove(_ element: FormatBuilder) -> [Element] {
//        self.filter { $0 != element }.compactMap { self.remove($0) }
//    }
    
//    public static func remove(lhs: inout Self, rhs: FormatEnum) -> Void {
//        lhs.filter { $0.type != rhs }.forEach { lhs.remove($0) }
//    }
    
//    public static func remove(lhs: inout Self, rhs: FormatBuilder) -> Void {
//        lhs.filter { $0 != rhs }.forEach { lhs.remove($0) }
//    }
    
//    public func remove(_ format: FormatEnum) -> Self {
//        self.filter { $0.type != format }
//    }
//    
//    public func remove(_ format: FormatBuilder) -> Self {
//        self.filter { $0 != format }
//    }
    
}

extension Set where Element == SystemBuilder {
    
    public static func random(_ range: Range<Int>) -> Self {
        
        let size: Int = Int.random(in: range)
        
        var set: Self = .init()
        
        while set.count < size {
            set.insert(.random)
        }
        
        return set
    }
    
}

extension Set where Element == TagBuilder {
    
    public func filter(_ tagType: TagType) -> Self {
        self.filter { $0.type == tagType }
    }
    
    public func filter(_ system: SystemBuilder) -> [PlatformBuilder] {
        self.compactMap { builder in
            switch builder {
            case .platform(let platform):
                return platform.system == system ? platform : nil
            default:
                return nil
            }
        }
    }
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.insert(rhs)
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.remove(rhs)
        return new
    }
    
    
//    static func +=(lhs: inout Self, rhs: Element) -> Void {
////        let key: Inputs.Key = rhs.type
////        lhs[key] = lhs.getOrDefault(key) + rhs.stringBuilder
//        lhs.insert(rhs)
//    }
//    
//    static func -=(lhs: inout Self, rhs: InputBuilder) -> Void {
////        let key: Inputs.Key = rhs.type
////        lhs[key] = lhs.getOrDefault(key) - rhs.stringBuilder
//    }
    
    
}

//extension Set where Element == PlatformBuilder {
//    
//    public static func random(_ size: Int) -> Self {
//        var set: Self = []
//        while set.count < size {
//            set.insert(.random)
//        }
//        return set
//    }
//    
//}
