//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

//extension Dictionary: Quantifiable { }

extension Dictionary where Key: Enumerable, Value: Defaultable {
    
//    public var enums: SortedSet<Key> {
//        let arr: [Key] = Key.cases.filter { self.get($0) != .defaultValue }
//        return .init(arr)
//    }
    
    public func get(_ key: Key) -> Value {
        self[key] ?? .defaultValue
    }
    
    public var isEmpty: Bool {
        self.keys.isEmpty
    }
    
}

//public extension Platforms {
//
//    typealias Builder = PlatformBuilder
//    
//    static func +=(lhs: inout Self, rhs: Value.Element) -> Void {
//        let key: Key = rhs.key.type
//        var value: Value = lhs.get(key)
//        value[rhs.key] = rhs.value
//        lhs[key] = value
//    }
//    
//    static func +=(lhs: inout Self, rhs: Builder) -> Void {
//        let key: Key = rhs.system.type
//        lhs[key] = lhs.get(key) + rhs
//    }
//    
//    static func -=(lhs: inout Self, rhs: Builder) -> Void {
//        let key: Key = rhs.system.type
//        lhs[key] = lhs.get(key) - rhs
//    }
//
//    func contains(_ builder: Builder) -> Bool {
//        let key: Key = builder.system.type
//        let value: Value = self.get(key)
//        return value.contains(builder)
//    }
//    
//    func get(_ system: Value.Key) -> Value.Value {
//        self.get(system.type).get(system)
//    }
//    
////    var systemKeys: [ValueKey] {
////        self.values.flatMap { $0.keys }
////    }
////    
////    var unused: [ValueKey] {
////        Systems.Key.cases.filter { self.systemKeys.lacks($0) }
////    }
//    
//}
//
//public extension Systems {
//    
//    static func +(lhs: Self, rhs: PlatformBuilder?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let key: Key = rhs.system
//            new[key] = new.get(key) + rhs
//        }
//        return new
//    }
//    
//    static func -(lhs: Self, rhs: PlatformBuilder?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let key: Key = rhs.system
//            new[key] = new.get(key) - rhs
//        }
//        
//        return new
//    }
//    
//    func contains(_ builder: PlatformBuilder) -> Bool {
//        let key: Key = builder.system
//        let value: Value = self.get(key)
//        return value.contains(builder)
//    }
//    
//}


// TODO: old code

//public extension Inputs {
//    
//    static func +=(lhs: inout Self, rhs: InputBuilder) -> Void {
//        let key: Inputs.Key = rhs.type
//        lhs[key] = lhs.getOrDefault(key) + rhs.stringBuilder
//    }
//    
//    static func -=(lhs: inout Self, rhs: InputBuilder) -> Void {
//        let key: Inputs.Key = rhs.type
//        lhs[key] = lhs.getOrDefault(key) - rhs.stringBuilder
//    }
//    
//    func toString(_ key: Key) -> String? {
//        let value: Value = self.getOrDefault(key)
//        return value.isEmpty ? nil : value.string
//    }
//    
//    func array(_ key: Key) -> [String] {
//        self.getOrDefault(key).array
//    }
//    
//}
//
//public extension Modes {
//    
//    static func +=(lhs: inout Self, rhs: Key) -> Void {
//        lhs[rhs] = true
//    }
//    
//    static func -=(lhs: inout Self, rhs: Key) -> Void {
//        lhs[rhs] = false
//    }
//    
//}
//
//public extension Platforms {
//    
//    func get(_ key: Key) -> Value {
//        self[key] ?? .defaultValue
//    }
//    
//    func get(_ key: Value.Key) -> Value.Value {
//        self.get(key.type).get(key)
//    }
//    
//    static func +=(lhs: inout Self, rhs: PlatformBuilder) -> Void {
//        let key: Key = rhs.system.type
//        lhs[key] = lhs.get(key) + rhs
//    }
//    
//    static func -=(lhs: inout Self, rhs: PlatformBuilder) -> Void {
//        let key: Key = rhs.system.type
//        lhs[key] = lhs.get(key) - rhs
//    }
//    
//    static func +=(lhs: inout Self, rhs: Systems.Element) -> Void {
//        let key: Key = rhs.key.type
//        var value: Value = lhs.get(key)
//        value[rhs.key] = rhs.value
//        lhs[key] = value
//    }
//    
////    func add(_ builder: PlatformBuilder) -> Element {
////        let key: Key = builder.system.type
////        var value: Value = self.get(key)
////        let element: Value.Element = value.add(builder)
////        value[element.key] = element.value
////        return (key, value)
////    }
////    
////    func delete(_ builder: PlatformBuilder) -> Element {
////        let key: Key = builder.system.type
////        var value: Value = self.get(key)
////        let element: Value.Element = value.delete(builder)
////        value[element.key] = element.value
////        return (key, value)
////    }
//    
//    func contains(_ builder: PlatformBuilder) -> Bool {
//        let key: Key = builder.system.type
//        let value: Value = self.get(key)
//        return value.contains(builder)
//    }
//    
//    var systemKeys: [Systems.Key] {
//        self.values.flatMap { $0.keys }
//    }
//    
//    var unused: [Systems.Key] {
//        Systems.Key.cases.filter { self.systemKeys.lacks($0) }
//    }
//    
////    var allKeys: [Key] {
////        self.keys.sorted()
////    }
//    
//}
//
//public extension Formats {
//    
//    init(_ builders: FormatBuilders) {
//        self.init()
//        builders.forEach { builder in
//            self[builder.type] = self.get(builder) + builder
//        }
//    }
//    
//    func get(_ format: FormatBuilder) -> Value {
//        self.get(format.type)
//    }
//    
//    func get(_ key: Key) -> Value {
//        self[key] ?? .defaultValue
//    }
//    
//    var allBuilders: FormatBuilders {
//        self.flatMap { $0.value }.toSet
//    }
//        
//    static func +=(lhs: inout Self, rhs: FormatBuilder?) -> Void {
//        if let rhs: FormatBuilder = rhs {
//            let key: Key = rhs.type
//            lhs[key] = lhs.getOrDefault(key) + rhs
//        }
//    }
//    
//    static func -=(lhs: inout Self, rhs: FormatBuilder?) -> Void {
//        if let rhs: FormatBuilder = rhs {
//            let key: Key = rhs.type
//            lhs[key] = lhs.getOrDefault(key) - rhs
//        }
//    }
//    
//    static func +(lhs: Self, rhs: PlatformBuilder?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let format: FormatBuilder = rhs.format
//            let key: Key = format.type
//            new[key] = new.get(format) + format
//        }
//        return new
//    }
//    
//    static func -(lhs: Self, rhs: PlatformBuilder?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let format: FormatBuilder = rhs.format
//            let key: Key = format.type
//            new[key] = new.get(format) - format
//        }
//        return new
//    }
//    
////        var new: Self = lhs
////
////        if let builder: Builder = rhs {
////            switch builder {
////            case .input(let i):
////                let key: Inputs.Key = i.type
////                var set: Inputs.Value = new.inputs.getOrDefault(key)
////                set.remove(i.stringBuilder)
////                new.inputs[key] = set
////            case .mode(let m):
////                new.modes[m] = false
////            case .platform(let p):
////                let element: Platforms.Element = new.platforms.delete(p)
////                new.platforms[element.key] = element.value
////            }
////
////            if new.added.contains(builder) {
////                new.added.remove(builder)
////            }
////
////            new.current.remove(builder)
////            new.deleted.insert(builder)
////
////        }
////
////        return new
//    
//    
////    func add(_ builder: PlatformBuilder) -> Element {
////        let format: FormatBuilder = builder.format
////        let key: Key = format.type
////        var value: Value = self.get(format)
////        value.insert(format)
////        return (key, value)
////    }
////    
////    func delete(_ builder: PlatformBuilder) -> Element {
////        let format: FormatBuilder = builder.format
////        let key: Key = format.type
////        let value: Value = self.get(format)
////        return (key, value.remove(format))
////    }
//    
//    func contains(_ builder: PlatformBuilder) -> Bool {
//        let format: FormatBuilder = builder.format
//        return self.contains(format)
////        let value: Value = self.get(format)
////        return value.contains(format)
//    }
//    
//    func contains(_ format: FormatBuilder) -> Bool {
//        let value: Value = self.get(format)
//        return value.contains(format)
//    }
//    
//}
//
//public extension Systems {
//    
//    func get(_ key: Key) -> Value {
//        self[key] ?? .defaultValue
//    }
//    
////    static func -=(lhs: inout Self, rhs: PlatformBuilder?) -> Void {
////        if let rhs: PlatformBuilder = rhs {
////            let key: Key = rhs.system
////            lhs[key] = lhs.get(key) - rhs
////        }
////    
//////        let element: Value.Element = value.delete(rhs)
//////        value[element.key] = element.value
//////        return (key, value)
////    }
//    
//    static func +(lhs: Self, rhs: PlatformBuilder?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let key: Key = rhs.system
//            new[key] = new.get(key) + rhs
//        }
////        new += rhs
//        return new
//    }
//    
//    static func -(lhs: Self, rhs: PlatformBuilder?) -> Self {
//        var new: Self = lhs
//        if let rhs: PlatformBuilder = rhs {
//            let key: Key = rhs.system
//            new[key] = new.get(key) - rhs
//        }
////        new -= rhs
//        return new
//    }
//    
////    func add(_ builder: PlatformBuilder) -> Element {
////        let key: Key = builder.system
////        var value: Value = self.get(key)
////        value += builder
//////        let element: Value.Element = value.add(builder)
//////        value[element.key] = element.value
////        return (key, value)
////    }
////    
////    func delete(_ builder: PlatformBuilder) -> Element {
////        let key: Key = builder.system
////        var value: Value = self.get(key)
////        let element: Value.Element = value.delete(builder)
////        value[element.key] = element.value
////        return (key, value)
////    }
//    
//    func contains(_ builder: PlatformBuilder) -> Bool {
//        let key: Key = builder.system
//        let value: Value = self.get(key)
//        return value.contains(builder)
//    }
//    
//}

//
//extension Inputs {
//
//    public func string(_ key: Key) -> String? {
//        let values: [String] = self.strings(key)
//        return values.isEmpty ? nil : values.joined(separator: ",\n")
//    }
//    
//    public func strings(_ key: Key) -> [String] {
//        if let value: Value = self[key] {
//            return value.map { $0.trim }.sorted()
//        } else {
//            return .defaultValue
//        }
//    }
//   
//}
//
//extension Platforms {
// 
//    public func array(_ key: Key) -> [Value.Element] {
//        self.getOrDefault(key).sorted()
//    }
//    
//    public func array(_ key: Key, _ format: FormatEnum) -> [Value.Element] {
//        self.array(key).filter { $0.type == format }
//    }
//    
//    public func get(_ key: Key?) -> Value {
//        if let key: Key = key {
//            return self.getOrDefault(key)
//        } else {
//            return .defaultValue
//        }
//    }
//
//    
//    public var unused: [Key] {
//        Key.cases.filter { !self.enums.contains($0) }
//    }
//    
//    
//    
////    public var builders: [PlatformBuilder] {
////        self.enums.flatMap { system in
////            self.getOrDefault(system).map { format in
////                    .init(system, format)
////            }
////        }
////    }
//
//}

