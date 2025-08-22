//
//  MyTestingFile2.swift
//  autosave
//
//  Created by Asia Serrano on 8/21/25.
//

import Foundation

// TagsMapProtocol
public protocol TagsMapProtocol: TempProtocol {
    
    associatedtype Key: Enumerable
    associatedtype Value: Defaultable
    
    typealias Record = TagBuilders
    typealias Values = [Key: Value]
    typealias Records = [Key: Record]
    typealias Keys = SortedSet<Key>
    
    var values: Values { get }
    var records: Records { get }
    
    static func -(lhs: Self, rhs: Key) -> Self
        
}

extension TagsMapProtocol {
    
    public subscript(key: Key) -> Value {
        get {
            self.values[key] ?? .defaultValue
        }
    }
    
    public subscript(key: Key) -> Record {
        get {
            self.records[key] ?? .defaultValue
        }
    }
 
}

// TagsMapProtocol Impl
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
    public private(set) var keys: Keys
    
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
    
}

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
    public private(set) var keys: Keys
    
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
    
}

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
    public private(set) var keys: Keys
    
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
    
    public subscript(key: Index) -> Record {
        get {
            self[key.0][key.1]
        }
    }

}

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
        let key: Key = rhs.0.type
        let value: Value = lhs[key]
        let record: Record = value[rhs]
        
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
    public private(set) var keys: Keys
    
    public private(set) var builders: TagBuilders

    public init() {
        self.values = .defaultValue
        self.records = .defaultValue
        self.keys = .defaultValue
        self.builders = .defaultValue
    }
        
}
