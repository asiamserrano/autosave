//
//  MyTestingFile2.swift
//  autosave
//
//  Created by Asia Serrano on 8/21/25.
//

import Foundation


/*
 - original group of tags
 - added group of tags
 - deleted group of tags
 
 - map of input to group of strings
 - group of modes
 - map of system categories to map of systems to map of format categories to map of formats
 
 - corresponding groups of tags to those maps
 
 __keys__
 InputEnum
 SystemEnum
 SystemBuilder
 SystemBuilder, FormatEnum
 
 __values__
 InputEnum
 InputBuilder (TagBuilder)
 Modes
 ModeEnum (TagBuilder)
 SystemEnum
 SystemBuilder
 PlatformBuilder (TagBuilder)
 (SystemBuilder, FormatEnum)
 
 !_adding_!
 - add to correct map
 - add to added
 - remove from deleted
 - add to builder map
 
 !_removing_!
 - remove from correct map
 - remove from added
 - add to remove deleted
 - remove from builder map
 
 *-maps-*
 - update value for key (map[key] = value + *update*)
 - remove entire key (map[key] = nil)
 - insert entire element (map[key] = value)
 
 
 
 */



//public protocol TagsSortedMapProtocol: NewTempProtocol where Element == Value.Element {
//    
//    associatedtype Key: Enumerable
//    associatedtype Value: TempProtocol
//    
//    typealias Keys = SortedSet<Key>
//    typealias Map = [Key: Value]
//    typealias MapElement = (key: Key, value: Value)
//    typealias ValueElement = (key: Key, value: Value.Element)
//    
//    init()
//    
//    subscript(key: Key) -> Value { get }
//    
////    static func +(lhs: Self, rhs: ValueElement) -> Void
//        
//    var map: Map { get }
//    
//}
//
//extension TagsSortedMapProtocol {
//    
//    public static var defaultValue: Self { .init() }
//    
//    public var quantity: Int { self.builders.count }
//    
//    public var builders: TagBuilders { .init(self.keys.flatMap { self[$0].builders }) }
//    
//    public var keys: Keys { .init(self.map.keys) }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(<#T##value: Hashable##Hashable#>)
//    }
//
//}
//
//public struct SortedMap<Key, Value>: TagsSortedMapProtocol where Key: Enumerable, Value: NewTagsSortedSetProtocol {
//    
//    public typealias Element = Value.Element
//    
//    
//    public private(set) var map: Map
//    
//    public init() {
//        self.map = .defaultValue
//    }
//    
//    public private(set) subscript (key: Key) -> Value {
//        get {
//            map[key] ?? .defaultValue
//        } set {
//            map[key] = newValue.isVacant ? nil : newValue
//        }
//    }
//    
//    public static func -->(lhs: inout Self, rhs: MapElement) -> Void {
//        lhs[rhs.key] = rhs.value
//    }
//    
////    public static func +=(lhs: inout Self, rhs: ValueElement) -> Void {
////        let key: Key = rhs.key
////        lhs --> (key: key, value: (lhs[key] + rhs.value))
////    }
//    
//    public static func +(lhs: Self, rhs: Element) -> Self {
//        var new: Self = lhs
//        
//        new --> (key: rhs.key, value: new[rhs.key] + rhs.value)
//        return new
//    }
//    
//    public static func -(lhs: Self, rhs: Element) -> Self {
//        var new: Self = lhs
//        
////        new --> (key: rhs.key, value: new[rhs.key] + rhs.value)
//        return new
////        var new: Self = lhs
//        
////        new --> (key: rhs.key, value: new[rhs.key] + rhs.value)
//    }
//        
//}



////public struct SystemSortedMap: TagsSortedMapProtocol {
////    
////    public typealias Key = SystemBuilder
////    public typealias Value = FormatBuilders
////    
////    public private(set) var map: [Key: Value]
////    
////    public init() {
////        self.map = .defaultValue
////    }
////        
////}
//
////public struct PlatformSortedMap: TagsSortedMapProtocol {
////    
////    public typealias Key = SystemEnum
////    public typealias Value = SystemSortedMap
////    
////    private var map: [Key: Value]
////    
////    public init() {
////        self.map = .defaultValue
////    }
////    
////    subscript (key: Key) -> Value {
////        get {
////            map[key] ?? .defaultValue
////        }
////    }
////    
////    public var keys: Keys { .init(self.map.keys) }
////        
////}
