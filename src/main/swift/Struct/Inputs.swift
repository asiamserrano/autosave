//
//  Inputs.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public struct Inputs: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.type
        let builder: TagBuilder = .input(rhs)
        
        // add the string to the correct key in key value map
        lhs.values --> (lhs[key] + rhs.stringBuilder, key)
        // add the tagbuilder to the correct key in key builder map
        lhs.records --> (lhs[key] + builder, key)
        // add the tagbuilder to tag builders
        lhs.builders += builder
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.type
        let builder: TagBuilder = .input(rhs)
        
        // remove the string to the correct key in key value map
        lhs.values --> (lhs[key] - rhs.stringBuilder, key)
        // remove the tagbuilder to the correct key in key builder map
        lhs.records --> (lhs[key] - builder, key)
        // remove the tagbuilder to tag builders
        lhs.builders -= builder
    }
    
    public static func -(lhs: Self, rhs: Key) -> Self {
        var new: Self = lhs
        // remove key from key value map
        new.values --> (nil, rhs)
        // remove key from key builder map
        new.records --> (nil, rhs)
        // remove tag builders for key from key builder map
        new.builders -= lhs[rhs]
        return new
    }
    
    public typealias Key = InputEnum
    public typealias Value = StringBuilders
    public typealias Element = InputBuilder
    
    public private(set) var values: Values
    public private(set) var records: Records
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.builders = .defaultValue
    }
    
}
