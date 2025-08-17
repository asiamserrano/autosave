//
//  NestedSortedMap.swift
//  autosave
//
//  Created by Asia Serrano on 8/8/25.
//

import Foundation

public struct NestedSortedMap<Key: Enumerable, Value: SortedMapProtocol>: SortedMapProtocol {
    public private(set) var keys: Keys
    private var map: [Key: Value]
    
    public init() {
        self.keys = .init()
        self.map = .init()
    }
}

public extension NestedSortedMap {
    
    static func --> (lhs: Self, rhs: (K, V?)) -> Self {
        let value: V = rhs.1 ?? .defaultValue
        var new: Self = lhs
        new[rhs.0] = value.isEmpty ? nil : value
        return new
    }
    
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
    
    func get(_ k: Key, _ v: Value) -> Element {
        .init(k, v)
    }

}

public extension Platforms {
    
    typealias Builder = PlatformBuilder
    
    static func + (lhs: Self, rhs: (V.K, Value.V.V.Element)) -> Self {
        let system: SystemBuilder = rhs.0
        let key: SystemEnum = system.type
        
        return lhs --> (key, lhs.get(key) + .init(system, rhs.1))
    }
    
    static func -=(lhs: inout Self, rhs: Element) -> Void {
        let value: V = rhs.value
        lhs[rhs.key] = value.isEmpty ? nil : value
    }
    
    static func +=(lhs: inout Self, rhs: V.Element) -> Void {
        let key: Key = rhs.key.type
        var value: Value = lhs.get(key)
        value[rhs.key] = rhs.value
        lhs[key] = value
    }
    
    static func +=(lhs: inout Self, rhs: Builder) -> Void {
        let key: Key = rhs.system.type
        lhs[key] = lhs.get(key) + rhs
    }
    
    static func -=(lhs: inout Self, rhs: Builder) -> Void {
        let key: Key = rhs.system.type
        lhs[key] = lhs.get(key) - rhs
    }
    
//    static func -=(lhs: inout Self, rhs: (Systems.K, Formats.K)) -> Void {
////        let key: Key = rhs.0.type
////        lhs[key] = lhs.get(key) - rhs
//    }
//    
//    static func -=(lhs: inout Self, rhs: Systems.K) -> Void {
//        lhs[rhs.type] = nil
//    }

    func contains(_ builder: Builder) -> Bool {
        let key: Key = builder.system.type
        let value: Value = self.get(key)
        return value.contains(builder)
    }
    
    func get(_ system: Value.K) -> Value.V {
        self.get(system.type).get(system)
    }
    
//    var systemKeys: [ValueKey] {
//        self.values.flatMap { $0.keys }
//    }
//
//    var unused: [ValueKey] {
//        Systems.Key.cases.filter { self.systemKeys.lacks($0) }
//    }
    
    var unused: SortedSet<Value.K> {
        .init(Value.K.cases.filter { self.flatMap { $0.value.keys }.lacks($0) })
    }
    
}

public extension Systems {
    
//    static func --> (lhs: Self, rhs: Element) -> Self {
//        let value: V = rhs.value
//        var new: Self = lhs
//        new[rhs.key] = value.isEmpty ? nil : value
//        return new
//    }
    
//    static func +(lhs: Self, rhs: (SystemBuilder, FormatBuilder)) -> Self {
//        lhs + .init(rhs.0, rhs.1)
//    }
    
    static func +(lhs: Self, rhs: PlatformBuilder?) -> Self {
        var new: Self = lhs
        if let rhs: PlatformBuilder = rhs {
            let key: Key = rhs.system
            new[key] = new.get(key) + rhs
        }
        return new
    }
    
    static func -(lhs: Self, rhs: PlatformBuilder?) -> Self {
        var new: Self = lhs
        if let rhs: PlatformBuilder = rhs {
            let key: Key = rhs.system
            new[key] = new.get(key) - rhs
        }
        
        return new
    }
    
    static func -(lhs: Self, rhs: K) -> Self {
        var new: Self = lhs
        new -= rhs
        return new
    }
    
    static func -=(lhs: inout Self, rhs: K) -> Void {
        lhs[rhs] = nil
    }
    
    
    
//    static func -(lhs: Self, rhs: (K, Formats.K)) -> Self {
//        var new: Self = lhs
//        let key: K = rhs.0
//        new[key] = new.get(key) - rhs.1
//        return new
//    }
    
    func contains(_ builder: PlatformBuilder) -> Bool {
        let key: Key = builder.system
        let value: Value = self.get(key)
        return value.contains(builder)
    }
    
}


//
//fileprivate extension SortedSet {
//    
//    static func -->(lhs: inout Self, rhs: Group) -> Void {
//        lhs.set = rhs
//        lhs.list = rhs.sorted()
//    }
//    
//}
