//
//  TagsMapProtocol.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public protocol TagsMapProtocol: TagsProtocol {
    
    associatedtype Key: Enumerable
    associatedtype Value: Universable
//    associatedtype Member: Any
    
    var values: Values { get }
    var records: Records { get }
    
    static func -=(lhs: inout Self, rhs: Key) -> Void
//    static func -->(lhs: inout Self, rhs: Member) -> Void
        
}

public extension TagsMapProtocol {
    
    typealias Record = TagBuilders
    typealias Values = [Key: Value]
    typealias Records = [Key: Record]
    typealias Keys = SortedSet<Key>

    static func -(lhs: Self, rhs: Key) -> Self {
        var new: Self = lhs
        new -= rhs
        return new
    }
    
    subscript(key: Key) -> Value {
        get {
            self.values[key] ?? .defaultValue
        }
    }
    
    subscript(key: Key) -> Record {
        get {
            self.records[key] ?? .defaultValue
        }
    }
    
    var keys: Keys {
        .init(self.values.keys)
    }
    
}

extension TagsMapProtocol where Value: SortedSetProtocol {
    
    func contains(_ element: Value.Element) -> Bool {
        let elements: [Value.Element] = self.values.flatMap { $0.value }
        return elements.contains(element)
    }
    
}
