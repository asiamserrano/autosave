//
//  Tagable.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation

public protocol Tagable: Identifiable, Stable, Comparable {
    var key: PropertySnapshot { get }
    var value: PropertySnapshot { get }
}

extension Tagable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.keyBuilder == rhs.keyBuilder {
            return lhs.valueBuilder < rhs.valueBuilder
        } else {
            return lhs.keyBuilder < rhs.keyBuilder
        }
    }
    
    public var id: Int {
        self.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key.builder)
        hasher.combine(self.value.builder)
    }
    
    private var keyBuilder: PropertyBuilder {
        self.key.builder
    }
    
    private var valueBuilder: PropertyBuilder {
        self.value.builder
    }
    
}
