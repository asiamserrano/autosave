//
//  Systems.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public struct Systems: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.system
        let builder: TagBuilder = .platform(rhs)

        // add the platformbuilder to the formatsmap of the correct key
        lhs.values --> (lhs[key] + rhs, key)
        // add the tagbuilder to the correct key in key builder map
        lhs.records --> (lhs[key] + builder, key)
        // add the tagbuilder to tag builders
        lhs.builders += builder

    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.system
        let builder: TagBuilder = .platform(rhs)
        
        // remove the platformbuilder to the formatsmap of the correct key
        lhs.values --> (lhs[key] - rhs, key)
        // remove the tagbuilder from the correct key in key builder map
        lhs.records --> (lhs[key] - builder, key)
        // remove the tagbuilder from the tag builders
        lhs.builders -= builder
    }
    
    public static func -(lhs: Self, rhs: Index) -> Self {
        let key: Key = rhs.0
        let format: FormatEnum = rhs.1
        let value: Value = lhs[key] // formatsmap
        let record: Record = value[format] // tagbuilders of the key in the formatsmap
        
        var new: Self = lhs
        // remove the formatenum key of the formatsmap from the key value map
        new.values --> (value - format, key)
        // remove the tagbuilders of the formatenum key of the formatsmap from the key builder map
        new.records --> (lhs[key] - record, key)
        // remove the tagbuilders of the formatenum key of the formatsmap from the tagbuilders
        new.builders -= record
        return new
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
        
    public typealias Key = SystemBuilder
    public typealias Value = Formats
    public typealias Element = PlatformBuilder
    public typealias Index = (Key, Value.Key)
    
    public private(set) var values: Values
    public private(set) var records: Records
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.builders = .defaultValue
    }

}
