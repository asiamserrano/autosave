//
//  SortedMapProtocol.swift
//  autosave
//
//  Created by Asia Serrano on 8/10/25.
//

import Foundation

public protocol SortedMapProtocol: Hashable, Defaultable, Quantifiable, RandomAccessCollection where Index == Keys.Index, Element: SortedMapElementProtocol, Element.K == K, Element.V == V {
    associatedtype K: Enumerable
    associatedtype V: Hashable & Defaultable
    associatedtype Keys: SortedSetProtocol where Keys.Element == K
    
    var keys: Keys { get }
    
    subscript(key: K) -> V? { get set }
    
    init()
    
    func get(_ key: K, _ v: V) -> Element
}

extension SortedMapProtocol {

    public static var defaultValue: Self { .init() }
    
    public func get(_ key: K) -> V {
        self[key] ?? .defaultValue
    }
    
    public func hash(into hasher: inout Hasher) {
        self.forEach { hasher.combine($0) }
    }
    
    public func index(after i: Index) -> Index {
        self.keys.index(after: i)
    }
    
    public var startIndex: Index {
        self.keys.startIndex
    }
    
    public var endIndex: Index {
        self.keys.endIndex
    }
    
    public var quantity: Int {
        self.keys.quantity
    }
    
    public subscript(index: Index) -> Element {
        get {
            let key: K = self.keys[index]
            let value: V = self.get(key)
            return self.get(key, value)
        }
    }
    
}
