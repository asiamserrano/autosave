//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary where Key == SystemBuilder, Value == [FormatBuilder] {
    
    public init(_ builders: [PlatformBuilder]) {
        self = .init(uniqueKeysWithValues: builders.map { item in
            let system: SystemBuilder = item.system
            let formatBuilders = builders.filter(system)
            return (system, formatBuilders)
        })
    }
    
    public var systems: [Key] {
        self.keys.sorted()        
    }
    
    public func getOrDefault(_ key: Key) -> Value {
        self[key] ?? .init()
    }
    
}
