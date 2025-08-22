//
//  Formats.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public struct Formats: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let format: FormatBuilder = rhs.format
        let key: Key = format.type
        let builder: TagBuilder = .platform(rhs)
        
        // add the formatbuilder to the correct key in key value map
        lhs.values --> (lhs[key] + rhs.format, key)
        // add the tagbuilder to the correct key in key builder map
        lhs.records --> (lhs[key] + builder, key)
        // add the tagbuilder to tag builders
        lhs.builders += builder

    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let format: FormatBuilder = rhs.format
        let key: Key = format.type
        let builder: TagBuilder = .platform(rhs)
        
        // remove the formatbuilder to the correct key in key value map
        lhs.values --> (lhs[key] - rhs.format, key)
        // remove the tagbuilder from the correct key in key builder map
        lhs.records --> (lhs[key] - builder, key)
        // remove the tagbuilder from the tag builders
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
    
    public typealias Key = FormatEnum
    public typealias Value = FormatBuilders
    public typealias Element = PlatformBuilder
    
    public private(set) var values: Values
    public private(set) var records: Records
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.builders = .defaultValue
    }
    
}
