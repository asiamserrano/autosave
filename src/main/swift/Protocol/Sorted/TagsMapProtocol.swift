//
//  TagsMapProtocol.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public protocol TagsMapProtocol: TagsProtocol {
    
    associatedtype Key: Enumerable
    associatedtype Value: Defaultable
    
    var values: Values { get }
    var records: Records { get }
        
}

public extension TagsMapProtocol {
    
    typealias Record = TagBuilders
    typealias Values = [Key: Value]
    typealias Records = [Key: Record]
    typealias Keys = SortedSet<Key>
    
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

