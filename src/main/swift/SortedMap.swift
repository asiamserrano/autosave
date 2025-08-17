//
//  SortedMap.swift
//  autosave
//
//  Created by Asia Serrano on 8/5/25.
//

import Foundation

public struct SortedMap<Key: Enumerable, Value: SortedSetProtocol>: SortedMapProtocol {
    public private(set) var keys: Keys
    private var map: [Key: Value]
    
    public init() {
        self.keys = .init()
        self.map = .init()
    }
}

public extension SortedMap {
    
    typealias Keys = SortedSet<Key>
    typealias Index = Keys.Index
    
    struct Element: SortedMapElementProtocol {
        public let key: Key
        public let value: Value
        
        public  init(_ key: K, _ value: V) {
            self.key = key
            self.value = value
        }
    }

    subscript(key: Key) -> Value? {
        get {
            self.map[key]
        }
        set {
            if let value: Value = newValue, value.isOccupied {
                self.keys += key
                self.map[key] = value
            } else {
                self.keys -= key
                self.map[key] = nil
            }
        }
    }

}

public extension Inputs {
    
    static func +=(lhs: inout Self, rhs: InputBuilder) -> Void {
        let key: InputEnum = rhs.type
        lhs[key] = lhs.get(key) + rhs.stringBuilder
    }
    
    static func -=(lhs: inout Self, rhs: InputBuilder) -> Void {
        let key: InputEnum = rhs.type
        lhs[key] = lhs.get(key) - rhs.stringBuilder
    }
    
    static func + (lhs: Self, rhs: (Key, String)) -> Self {
        let key: Key = rhs.0
        var new: Self = lhs
        new[key] = new.get(key) + .string(rhs.1)
        return new
    }
    
//    func toString(_ key: Key) -> String? {
//        let value: Value = self.get(key)
//        return value.isEmpty ? nil : value.string
//    }
//    
//    func array(_ key: Key) -> [String] {
//        self.get(key).array
//    }
    
}

public extension Formats {
    
    typealias Format = FormatBuilder
    typealias Platform = PlatformBuilder
    
    init(_ value: Value) {
        self.init()
        value.forEach { builder in
            self[builder.type] = self.get(builder) + builder
        }
    }
    
    static func -=(lhs: inout Self, rhs: FormatEnum?) -> Void {
        if let rhs: FormatEnum = rhs {
            lhs[rhs] = nil
        }
    }
    
    static func +=(lhs: inout Self, rhs: Format?) -> Void {
        if let rhs: FormatBuilder = rhs {
            let key: Key = rhs.type
            lhs[key] = lhs.get(key) + rhs
        }
    }
    
    static func -=(lhs: inout Self, rhs: Format?) -> Void {
        if let rhs: FormatBuilder = rhs {
            let key: Key = rhs.type
            lhs[key] = lhs.get(key) - rhs
        }
    }
    
    static func +(lhs: Self, rhs: Platform?) -> Self {
        var new: Self = lhs
        if let rhs: PlatformBuilder = rhs {
            let format: FormatBuilder = rhs.format
            let key: Key = format.type
            new[key] = new.get(format) + format
        }
        return new
    }
    
    static func -(lhs: Self, rhs: Platform?) -> Self {
        var new: Self = lhs
        if let rhs: PlatformBuilder = rhs {
            let format: FormatBuilder = rhs.format
            let key: Key = format.type
            new[key] = new.get(format) - format
        }
        return new
    }
    
    static func -(lhs: Self, rhs: Key?) -> Self {
        var new: Self = lhs
        if let rhs: FormatEnum = rhs {
            new[rhs] = nil
        }
        return new
    }
    
    static func -(lhs: Self, rhs: Format?) -> Self {
        var new: Self = lhs
        if let format: Format = rhs {
            let key: Key = format.type
            new[key] = new.get(format) - format
        }
        return new
    }
    
    func contains(_ platform: Platform) -> Bool {
        let format: FormatBuilder = platform.format
        return self.contains(format)
    }
    
    func contains(_ format: Format) -> Bool {
        let value: Value = self.get(format)
        return value.contains(format)
    }
    
    func get(_ format: Format) -> Value {
        self.get(format.type)
    }
    
}


// TODO: OLD

//public struct SortedMap<K: Enumerable, V: Hashable & Comparable>: SortedMapProtocol {
//    
//    public private(set) var keys: Keys = .init()
//    private var map: [Key: Value] = .init()
//    
//}
//
//public extension SortedMap {
//    
//    typealias Key = K
//    typealias Keys = SortedSet<Key>
//    typealias Value = SortedSet<V>
//    typealias Index = Keys.Index
//    
//    struct Element: Hashable, Comparable {
//        
//        public static func < (lhs: Self, rhs: Self) -> Bool {
//            if lhs.key == rhs.key {
//                return lhs.value < rhs.value
//            } else {
//                return lhs.key < rhs.key
//            }
//        }
//        
//        let key: Key
//        let value: Value
//        
//        init(_ key: Key, _ value: Value) {
//            self.key = key
//            self.value = value
//        }
//    }
//    
//    subscript(index: Index) -> Element {
//        get {
//            let key: Key = self.keys[index]
//            let value: Value = self.get(key)
//            return .init(key, value)
//        }
//    }
//    
//    subscript(key: Key) -> Value? {
//        get {
//            self.map[key]
//        }
//        set {
//            if let value: Value = newValue, value.isOccupied {
//                self.keys += key
//                self.map[key] = value
//            } else {
//                self.keys -= key
//                self.map[key] = nil
//            }
//        }
//    }
//    
//    func get(_ key: Key) -> Value {
//        self[key] ?? .defaultValue
//    }
//    
//    func index(after i: Index) -> Index {
//        self.keys.index(after: i)
//    }
//    
//    var startIndex: Index {
//        self.keys.startIndex
//    }
//    
//    var endIndex: Index {
//        self.keys.endIndex
//    }
//    
//}
//
//extension SortedMap: Hashable {
//    
//    public func hash(into hasher: inout Hasher) {
//        self.forEach { hasher.combine($0) }
//    }
//    
//}
//
//extension SortedMap: Defaultable {
//    
//    public static var defaultValue: Self { .init() }
//    
//}
//
//extension SortedMap: Comparable {
//    
//    public static func < (lhs: Self, rhs: Self) -> Bool {
//        lhs.hashValue < rhs.hashValue
//    }
//    
//}
//
//
//public extension Inputs {
//    
//    static func +=(lhs: inout Self, rhs: InputBuilder) -> Void {
//        let key: Inputs.Key = rhs.type
//        lhs[key] = lhs.get(key) + rhs.stringBuilder
//    }
//    
//    static func -=(lhs: inout Self, rhs: InputBuilder) -> Void {
//        let key: Inputs.Key = rhs.type
//        lhs[key] = lhs.get(key) - rhs.stringBuilder
//    }
//    
////    func toString(_ key: Key) -> String? {
////        let value: Value = self.get(key)
////        return value.isEmpty ? nil : value.string
////    }
////    
////    func array(_ key: Key) -> [String] {
////        self.get(key).array
////    }
//    
//}
//
//public extension Formats {
//    
//    typealias Format = FormatBuilder
//    typealias Platform = PlatformBuilder
//    
//    init(_ value: Value) {
//        self.init()
//        value.forEach { builder in
//            self[builder.type] = self.get(builder) + builder
//        }
//    }
//    
//    static func +=(lhs: inout Self, rhs: Format?) -> Void {
//        if let rhs: FormatBuilder = rhs {
//            let key: Key = rhs.type
//            lhs[key] = lhs.get(key) + rhs
//        }
//    }
//    
//    static func -=(lhs: inout Self, rhs: Format?) -> Void {
//        if let rhs: FormatBuilder = rhs {
//            let key: Key = rhs.type
//            lhs[key] = lhs.get(key) - rhs
//        }
//    }
//    
//    static func +(lhs: Self, rhs: Platform?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let format: FormatBuilder = rhs.format
//            let key: Key = format.type
//            new[key] = new.get(format) + format
//        }
//        return new
//    }
//    
//    static func -(lhs: Self, rhs: Platform?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let format: FormatBuilder = rhs.format
//            let key: Key = format.type
//            new[key] = new.get(format) - format
//        }
//        return new
//    }
//    
//    func contains(_ platform: Platform) -> Bool {
//        let format: FormatBuilder = platform.format
//        return self.contains(format)
//    }
//    
//    func contains(_ format: Format) -> Bool {
//        let value: Value = self.get(format)
//        return value.contains(format)
//    }
//    
//    func get(_ format: Format) -> Value {
//        self.get(format.type)
//    }
//    
//}

//extension SortedMap where Element == StringBuilder {
//    
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
//    public static func random(_ range: Range<Int>) -> Self {
//        let size: Int = Int.random(in: range)
//        
//        var set: Self = .defaultValue
//        while set.count < size {
//            let element: Element = .string(.random)
//            set.insert(element)
//        }
//        return set
//    }
//    
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
//    
//}
