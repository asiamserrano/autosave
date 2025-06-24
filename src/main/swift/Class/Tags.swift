//
//  Tags.swift
//  autosave
//
//  Created by Asia Serrano on 6/24/25.
//

import Foundation

public struct TagsMap {
    
    private var inputs: [InputEnum: InputValue]
    private var modes: [ModeEnum: Bool]
    private var platforms: [SystemBuilder: PlatformValue]
    
    public init() {
        self.inputs = .init()
        self.modes = .init()
        self.platforms = .init()
    }
    
    public mutating func add(_ entry: Entry) -> Void {
        switch entry {
        case .input(let i):
            let key: InputEnum = i.type
            var set: InputValue = inputs.getOrDefault(key)
            set.insert(i.stringBuilder)
            self.inputs[key] = set
        case .mode(let m):
            self.modes[m] = true
        case .platform(let p):
            let key: SystemBuilder = p.system
            var set: PlatformValue = platforms.getOrDefault(key)
            set.insert(p.format)
            self.platforms[key] = set
        }
    }
    
    public mutating func delete(_ entry: Entry) -> Void {
        switch entry {
        case .input(let i):
            let key: InputEnum = i.type
            self.inputs[key] = inputs.getOrDefault(key).delete(i.stringBuilder)
        case .mode(let m):
            self.modes[m] = false
        case .platform(let p):
            let key: SystemBuilder = p.system
            self.platforms[key] = platforms.getOrDefault(key).delete(p.format)
        }
    }
    
    public func get(_ key: Key) -> [Entry] {
        switch key {
        case .inputs(let i):
            let set: InputValue = inputs.getOrDefault(i)
            return set.inputs(i).map { .input($0) }
        case .modes:
            return modes.compactMap { $1 ? .mode($0) : nil }
        case .platforms(let s):
            let set: PlatformValue = platforms.getOrDefault(s)
            return set.platforms(s).map { .platform($0) }
        }
    }
    
}

extension TagsMap {
    
    public typealias Entry = TagBuilder
    
    private typealias InputValue = Set<StringBuilder>
    private typealias PlatformValue = Set<FormatBuilder>
    
    public enum Key {
        case inputs(InputEnum)
        case modes
        case platforms(SystemBuilder)
    }
//
//    public enum Value {
//        case inputs(Set<StringBuilder>)
//        case modes(Bool)
//        case platforms(Set<FormatBuilder>)
//    }
//
//    public enum Element: Hashable, Comparable {
//                
//        public static func == (lhs: Self, rhs: Self) -> Bool {
//            lhs.hashValue == rhs.hashValue
//        }
//        
//        public static func < (lhs: Self, rhs: Self) -> Bool {
//            lhs.entry < rhs.entry
//        }
//        
//        case inputs(InputBuilder)
//        case modes(ModeEnum, Bool)
//        case platforms(PlatformBuilder)
//        
//        public var entry: Entry {
//            switch self {
//            case .inputs(let i):
//                return .input(i)
//            case .modes(let m, _):
//                return .mode(m)
//            case .platforms(let p):
//                return .platform(p)
//            }
//        }
//        
//        public var bool: Bool {
//            switch self {
//            case .modes(_, let bool):
//                return bool
//            default:
//                return true
//            }
//        }
//        
//        public func hash(into hasher: inout Hasher) {
//            hasher.combine(self.entry)
//            hasher.combine(self.bool)
//        }
//    }
    
}


//public enum TagsMapElement: Hashable, Comparable {
//    
//    public static func < (lhs: Self, rhs: Self) -> Bool {
//        lhs.key < rhs.key
//    }
//    
//    case inputs(InputEnum, Set<StringBuilder>)
//    case modes(ModeEnum, Bool)
//    case platforms(SystemBuilder, Set<FormatBuilder>)
//    
//    public var category: TagCategory {
//        switch self {
//        case .inputs:
//            return .input
//        case .modes:
//            return .mode
//        case .platforms:
//            return .platform
//        }
//    }
//    
//    public var key: TagsMapKey {
//        switch self {
//        case .inputs(let i, _):
//            return .inputs(i)
//        case .modes(let m, _):
//            return .modes(m)
//        case .platforms(let s, _):
//            return .platforms(s)
//        }
//    }
//    
//    public var value: TagsMapValue {
//        switch self {
//        case .inputs(_, let s):
//            return .inputs(s)
//        case .modes(_, let b):
//            return .modes(b)
//        case .platforms(_, let s):
//            return .platforms(s)
//        }
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.key)
//        switch self.value {
//        case .inputs(let set):
//            set.sorted().forEach { hasher.combine($0) }
//        case .modes(let bool):
//            hasher.combine(bool)
//        case .platforms(let set):
//            set.sorted().forEach { hasher.combine($0) }
//        }
//    }
//    
//}
