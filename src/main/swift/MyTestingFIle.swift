//
//  MyTestingFIle.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/20/25.
//

import Foundation

// TempProtocol
public protocol TempProtocol: Defaultable, Stable, Quantifiable {
    
    associatedtype Element: Hashable & Comparable

    static func +=(lhs: inout Self, rhs: Element) -> Void
    static func -=(lhs: inout Self, rhs: Element) -> Void
    
    var builders: TagBuilders { get }
    
    init()
}

extension TempProtocol {
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
//    public static func ~(lhs: Self, rhs: Element) -> Self? {
//        let new: Self = lhs - rhs
//        return new.isVacant ? nil : new
//    }
//    
    public static var defaultValue: Self { .init() }
    
    public var quantity: Int { builders.count }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(builders)
    }
    
}

// TagsSortedSetProtocol
public protocol TagsSortedSetProtocol: TempProtocol {
        
    typealias Elements = SortedSet<Element>
    typealias Index = Elements.Index
    
    var elements: Elements { get }
    var builders: TagBuilders { get }
        
}

extension TagsSortedSetProtocol {
    
    public subscript(index: Index) -> Element {
        get { elements[index] }
    }
    
}


// TagsSortedSetProtocol Impl
public struct StringBuilders: TagsSortedSetProtocol {
    
    public typealias Element = StringBuilder
    
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements += rhs
        lhs.builders += .input(lhs.input, rhs)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements -= rhs
        lhs.builders -= .input(lhs.input, rhs)
    }
    
    public private(set) var elements: Elements
    public private(set) var builders: TagBuilders
    
    public let input: InputEnum
    
    public init() {
        self.elements = .defaultValue
        self.builders = .defaultValue
        self.input = .defaultValue
    }
    
    public init(_ i: InputEnum, _ e: Elements) {
        self.elements = e
        self.builders = .init(e.map { .input(i, $0) })
        self.input = i
    }

}

public struct ModeEnums: TagsSortedSetProtocol {
    
    public typealias Element = ModeEnum
    
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements += rhs
        lhs.builders += .mode(rhs)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements -= rhs
        lhs.builders -= .mode(rhs)
    }
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new += rhs
        return new
    }
    
    public private(set) var elements: Elements
    public private(set) var builders: TagBuilders
        
    public init(_ e: Elements) {
        self.elements = e
        self.builders = .init(e.map { .mode($0)})
    }
    
    public init() {
        self.elements = .defaultValue
        self.builders = .defaultValue
    }

}

public struct FormatBuilders: TagsSortedSetProtocol {
    
    public typealias Element = FormatBuilder
    public typealias Key = (SystemBuilder, FormatEnum)
    
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements += rhs
        lhs.builders += .platform(lhs.system, rhs)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        lhs.elements -= rhs
        lhs.builders -= .platform(lhs.system, rhs)
    }
    
    
    public static func -->(lhs: inout Self, rhs: Elements) -> Void { lhs.elements = rhs }
    
    public private(set) var elements: Elements
    public private(set) var builders: TagBuilders
    
    private let key: Key
    
    public init(_ s: SystemBuilder, _ f: FormatEnum, _ e: Elements = .defaultValue) {
        self.elements = e
        self.builders = .init(e.map { .platform(s, $0) })
        self.key = (s, f)
    }
    
    public init(_ k: Key, _ e: Elements = .defaultValue) {
        self.init(k.0, k.1, e)
    }
    
    public init() {
        self.elements = .defaultValue
        self.builders = .defaultValue
        self.key = (.defaultValue, .defaultValue)
    }
    
    public var system: SystemBuilder { self.key.0 }
    public var format: FormatEnum { self.key.1 }

}


// TagsMapProtocol
public protocol TagsMapProtocol: TempProtocol {
    
    associatedtype Key: Enumerable
    associatedtype Value: TempProtocol
    
    typealias Map = [Key: Value]
    typealias Keys = SortedSet<Key>
    
    var map: Map { get }
    
    static func -(lhs: Self, rhs: Key) -> Self
    
}

extension TagsMapProtocol {
    
//    public static func -->(lhs: inout Self, rhs: (Key, Value)) -> Void {
//        let value: Value = rhs.1
//        lhs.map[rhs.0] = value.isVacant ? nil : value
//    }
    
//    public static func ~(lhs: Self, rhs: Key) -> Self? {
//        let new: Self = lhs - rhs
//        return new.isVacant ? nil : new
//    }
    
    public subscript(key: Key) -> Value {
        get {
            self.map[key] ?? .defaultValue
        }
    }
    
}

// TagsMapProtocol Impl
public struct InputsMap: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.type
        let value: Value = lhs[key]
        lhs.builders += .input(rhs)
        lhs.map --> (value + rhs.stringBuilder, key)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.type
        let value: Value = lhs[key]
        lhs.builders -= .input(rhs)
        lhs.map --> (value - rhs.stringBuilder, key)
    }
    
    public static func -(lhs: Self, rhs: Key) -> Self {
        var new: Self = lhs
        let value: Value = new[rhs]
        new.builders -= value.builders
        new.map --> (nil, rhs)
        return new
    }
    
    public typealias Key = InputEnum
    public typealias Value = StringBuilders
    public typealias Element = InputBuilder
    
    public private(set) var map: Map
    public private(set) var keys: Keys
    public private(set) var builders: TagBuilders

    public init() {
        self.map = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
    
}

public struct FormatsMap: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.type
        let value: Value = lhs[key]
        lhs.builders += .platform(value.system, rhs)
        lhs.map --> (value + rhs, key)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.type
        let value: Value = lhs[key]
        lhs.builders -= .platform(value.system, rhs)
        lhs.map --> (value - rhs, key)
    }
    
    public static func -(lhs: Self, rhs: Key) -> Self {
        var new: Self = lhs
        let value: Value = new[rhs]
        new.builders -= value.builders
        new.map --> (nil, rhs)
        return new
    }
    
    public typealias Key = FormatEnum
    public typealias Value = FormatBuilders
    public typealias Element = Value.Element
    
    public private(set) var map: Map
    public private(set) var keys: Keys
    public private(set) var builders: TagBuilders

    public init() {
        self.map = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
    
}

public struct SystemsMap: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.system
        let value: Value = lhs[key]
        let format: FormatBuilder = rhs.format
        lhs.builders += .platform(key, format)
        lhs.map --> (value + format, key)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.system
        let value: Value = lhs[key]
        let format: FormatBuilder = rhs.format
        lhs.builders -= .platform(key, format)
        lhs.map --> (value + format, key)
    }

    public static func -(lhs: Self, rhs: Key) -> Self {
        var new: Self = lhs
        let value: Value = new[rhs]
        new.builders -= value.builders
        new.map --> (nil, rhs)
        return new
    }
    
    public static func -(lhs: Self, rhs: (Key, Value.Key)) -> Self {
        var new: Self = lhs
        let key: Key = rhs.0
        let format: FormatEnum = rhs.1
        let value: Value = new[key]
        new.builders -= value[format].builders
        new.map --> (value - format, key)
        return new
    }
    
//    public static func ~(lhs: Self, rhs: Index) -> Self? {
//        let new: Self = lhs - rhs
//        return new.isVacant ? nil : new
//    }
    
    public typealias Key = SystemBuilder
    public typealias Value = FormatsMap
    public typealias Element = PlatformBuilder
    public typealias Index = (Key, Value.Key)
    
    public private(set) var map: Map
    public private(set) var keys: Keys
    public private(set) var builders: TagBuilders

    public init() {
        self.map = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
    
}

public struct PlatformsMap: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let system: SystemBuilder = rhs.system
        let key: Key = system.type
        let value: Value = lhs[key]
        let format: FormatBuilder = rhs.format
        lhs.builders += .platform(system, format)
        lhs.map --> (value + rhs, key)
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let system: SystemBuilder = rhs.system
        let key: Key = system.type
        let value: Value = lhs[key]
        let format: FormatBuilder = rhs.format
        lhs.builders -= .platform(system, format)
        lhs.map --> (value - rhs, key)
    }

    public static func -(lhs: Self, rhs: Key) -> Self {
        var new: Self = lhs
        let value: Value = new[rhs]
        new.builders -= value.builders
        new.map --> (nil, rhs)
        return new
    }
    
    public static func -(lhs: Self, rhs: Value.Key) -> Self {
        var new: Self = lhs
        let key: Key = rhs.type
        let value: Value = new[key]
        new.builders -= value[rhs].builders
        new.map --> (value - rhs, key)
        return new
    }
    
    public static func -(lhs: Self, rhs: Index) -> Self {
        var new: Self = lhs
        let system: SystemBuilder = rhs.0
        let key: Key = system.type
        let format: FormatEnum = rhs.1
        let value: Value = new[key]
        new.builders -= value[system][format].builders
        new.map --> (value - (system, format), key)
        return new
    }
    
    public typealias Key = SystemEnum
    public typealias Value = SystemsMap
    public typealias Element = PlatformBuilder
    public typealias Index = Value.Index
    
    public private(set) var map: Map
    public private(set) var keys: Keys
    public private(set) var builders: TagBuilders

    public init() {
        self.map = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
        
}

//public struct PlatformsMap: TagsMapProtocol {
//        
//    public static func += (lhs: inout Self, rhs: Element) -> Void {
//        let key: Key = rhs.system
//        let value: Value = lhs[key]
//        let format: FormatBuilder = rhs.format
//        lhs.builders += .platform(key, format)
//        lhs.map[key] = value + format
//    }
//    
//    public static func -= (lhs: inout Self, rhs: Element) -> Void {
//        let key: Key = rhs.system
//        let value: Value = lhs[key]
//        let format: FormatBuilder = rhs.format
//        lhs.builders -= .platform(key, format)
//        lhs.map --> (key, value ~ format)
//    }
//
//    public static func -(lhs: Self, rhs: Key) -> Self {
//        var new: Self = lhs
//        let value: Value = new[rhs]
//        new.builders -= value.builders
//        new.map --> (rhs, nil)
//        return new
//    }
//    
//    public static func -(lhs: Self, rhs: (Key, Value.Key)) -> Self {
//        var new: Self = lhs
//        let key: Key = rhs.0
//        let format: FormatEnum = rhs.1
//        let value: Value = new[key]
//        new.builders -= value[format].builders
//        new.map --> (key, value ~ format)
//        return new
//    }
//    
//    public typealias Key = SystemEnum
//    public typealias Value = SystemsMap
//    public typealias Element = PlatformBuilder
//    
//    public private(set) var map: Map
//    public private(set) var keys: Keys
//    public private(set) var builders: TagBuilders
//
//    public init() {
//        self.map = .defaultValue
//        self.keys = .defaultValue
//        self.builders = .defaultValue
//    }
//    
//}



//public struct StringBuilders: TagsSortedSetProtocol {
//
//    public typealias Element = StringBuilder
//    public typealias Index = Elements.Index
//
//    private static func getBuilders(_ input: InputEnum?, _ elements: Elements) -> TagBuilders {
//        if let input: InputEnum = input {
//            let array: [TagBuilder] = elements.map { .input(input, $0) }
//            return .init(array)
//        } else {
//            return .defaultValue
//        }
//    }
//
//    public static func -->(lhs: inout Self, rhs: Elements) -> Void {
//        lhs.elements = rhs
//        lhs.builders = getBuilders(lhs.input, rhs)
//    }
//
//    public static func += (lhs: inout Self, rhs: Element) -> Void {
//        lhs.elements += rhs
//        if let input: InputEnum = lhs.input {
//            lhs.builders += .input(input, rhs)
//        }
//    }
//
//    public static func -= (lhs: inout Self, rhs: Element) -> Void {
//        lhs.elements -= rhs
//        if let input: InputEnum = lhs.input {
//            lhs.builders -= .input(input, rhs)
//        }
//    }
//
//    public static func +(lhs: Self, rhs: Element) -> Self {
//        var new: Self = lhs
//        new += rhs
//        return new
//    }
//
//    public static func -(lhs: Self, rhs: Element) -> Self {
//        var new: Self = lhs
//        new += rhs
//        return new
//    }
//
//    public private(set) var elements: Elements
//    public private(set) var builders: TagBuilders
//
//    public let input: InputEnum?
//
//    public init() {
//        self.elements = .defaultValue
//        self.builders = .defaultValue
//        self.input = .defaultValue
//    }
//
//    public init(_ i: InputEnum, _ e: Elements) {
//        self.elements = e
//        self.builders = Self.getBuilders(i, e)
//        self.input = i
//    }
//
//}



    // break


//public struct SystemBuilderTags: TagsSortedSetProtocol {
//    
//    public typealias Element = StringBuilder
//    public typealias Index = Elements.Index
//    
//    public static func -->(lhs: inout Self, rhs: Elements) -> Void { lhs.elements = rhs }
//    
//    public private(set) var elements: Elements
//    
//    public let input: InputEnum?
//    
//    public init() {
//        self.elements = .defaultValue
//        self.input = .defaultValue
//    }
//    
//    public init(_ i: InputEnum, _ e: Elements) {
//        self.elements = e
//        self.input = i
//    }
//    
//    public var arr: Arr {
//        if let input: InputEnum = self.input {
//            return self.elements.map { .input(input, $0) }
//        } else {
//            return .defaultValue
//        }
//    }
//    
//}
