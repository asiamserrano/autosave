//
//  Platforms.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public struct Platforms: TagsMapProtocol {
        
    public static func += (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.system.type
        let builder: TagBuilder = .platform(rhs)

        // add the platformbuilder to the systemsmap of the correct key
        lhs.values --> (lhs[key] + rhs, key)
        // add the tagbuilder to the correct key in key builder map
        lhs.records --> (lhs[key] + builder, key)
        // add the tagbuilder to tag builders
        lhs.builders += builder
    }
    
    public static func -= (lhs: inout Self, rhs: Element) -> Void {
        let key: Key = rhs.system.type
        let builder: TagBuilder = .platform(rhs)
        
        // remove the platformbuilder from the systemsmap of the correct key
        lhs.values --> (lhs[key] - rhs, key)
        // remove the tagbuilder from the correct key in key builder map
        lhs.records --> (lhs[key] - builder, key)
        // remove the tagbuilder from tag builders
        lhs.builders -= builder
    }
    
    public static func -(lhs: Self, rhs: Index) -> Self {
        let system: SystemBuilder = rhs.0
        let key: Key = system.type
        let value: Value = lhs[key]
        let record: Record = value[system][rhs.1]
        
        var new: Self = lhs
        // remove the formatenum key of the formatsmap from the systembuilder key of the systemsmap from the key value map
        new.values --> (lhs[key] - rhs, key)
        // remove the tag builders of formatenum key of the formatsmap from the systembuilder key of the systemsmap from the key value map
        new.records --> (lhs[key] - record, key)
        // remove the tag builders of formatenum key of the formatsmap from the systembuilder key of the systemsmap from the tag builders
        new.builders -= record
        return new
    }

    public static func -(lhs: Self, rhs: Value.Key) -> Self {
        let key: Key = rhs.type
        let value: Value = lhs[key]
        let record: Record = value[rhs]
        
        var new: Self = lhs
        // remove the systembuilder from the systemsmap for the correct key
        new.values --> (value - rhs, key)
        // remove the tagbuilders of the systembuilder key in the systemsmap from the key builder map
        new.records --> (lhs[key] - record, key)
        // remove the tagbuilders of the systembuilder key in the systemsmap from the tag builders
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
        
    public typealias Key = SystemEnum
    public typealias Value = Systems
    public typealias Element = PlatformBuilder
    public typealias Index = Value.Index
    
    public private(set) var values: Values
    public private(set) var records: Records
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.builders = .defaultValue
    }
        
}
