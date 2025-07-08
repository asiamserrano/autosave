//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary where Key: Enumerable, Value: Defaultable {
    
    public var enums: [Key] {
        Key.cases.filter { self.getOrDefault($0) != .defaultValue }.sorted()
    }
    
    public func getOrDefault(_ key: Key) -> Value {
        self[key] ?? .defaultValue
    }
    
    public var isEmpty: Bool {
        self.keys.isEmpty
    }
    
}

extension Tags.Inputs {

    public func string(_ key: Key) -> String? {
        let values: [String] = self.strings(key)
        return values.isEmpty ? nil : values.joined(separator: ",\n")
    }
    
    public func strings(_ key: Key) -> [String] {
        if let value: Value = self[key] {
            return value.map { $0.trim }.sorted()
        } else {
            return .defaultValue
        }
    }
   
}

extension Tags.Platforms {
 
    public func array(_ key: Key) -> [Value.Element] {
        self.getOrDefault(key).sorted()
    }

}
