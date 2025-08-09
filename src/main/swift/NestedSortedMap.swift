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
    
    typealias Keys = SortedSet<Key>
    typealias Index = Keys.Index
    
    struct Element: Hashable {
        let key: Key
        let value: Value
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
        .init(key: k, value: v)
    }

}

public extension Platforms {

    typealias Builder = PlatformBuilder
    
    static func +=(lhs: inout Self, rhs: Value.Element) -> Void {
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
    
}

public extension Systems {
    
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
    
    func contains(_ builder: PlatformBuilder) -> Bool {
        let key: Key = builder.system
        let value: Value = self.get(key)
        return value.contains(builder)
    }
    
}
