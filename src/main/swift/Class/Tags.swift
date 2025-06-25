//
//  Tags.swift
//  autosave
//
//  Created by Asia Serrano on 6/24/25.
//

import Foundation

// TODO: Fix this
public struct TagsMap {
    
    public static func fromModels(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self? {
        var map: Self = .init()
        
        relations.forEach { relation in
            if let key: PropertyModel = properties.get(relation.key_uuid) {
                let property: PropertyBuilder = .fromModel(key)
                switch property {
                case .input(let i):
                    let builder: TagBuilder = .input(i)
                    map.add(builder)
                case .selected(let s):
                    switch s {
                    case .mode(let m):
                        let builder: TagBuilder = .mode(m)
                        map.add(builder)
                    default:
                        if let value: PropertyModel = properties.get(relation.value_uuid),
                           let platform: PlatformBuilder = .fromModels(key, value) {
                            let builder: TagBuilder = .platform(platform)
                            map.add(builder)
                        }
                    }
                }
            }
        }
        
        return map.keys.isEmpty ? nil : map
    }
    
    private var inputs: Inputs
    private var modes: Modes
    private var platforms: Platforms
    
    private init() {
        self.inputs = .init()
        self.modes = .init()
        self.platforms = .init()
    }
    
    public mutating func add(_ builder: Builder) -> Void {
        switch builder {
        case .input(let i):
            let key: Inputs.Key = i.type
            var set: Inputs.Value = inputs.getOrDefault(key)
            set.insert(i.stringBuilder)
            self.inputs[key] = set
        case .mode(let m):
            self.modes[m] = true
        case .platform(let p):
            let key: Platforms.Key = p.system
            var set: Platforms.Value = platforms.getOrDefault(key)
            set.insert(p.format)
            self.platforms[key] = set
        }
    }
    
    public mutating func delete(_ builder: Builder) -> Void {
        switch builder {
        case .input(let i):
            let key: Inputs.Key = i.type
            self.inputs[key] = inputs.getOrDefault(key).delete(i.stringBuilder)
        case .mode(let m):
            self.modes[m] = false
        case .platform(let p):
            let key: Platforms.Key = p.system
            self.platforms[key] = platforms.getOrDefault(key).delete(p.format)
        }
    }
        
    //    public func get(_ element: Element) -> [Entry] {
    //        switch element {
    //        case .inputs(let i):
    //            let set: InputValue = inputs.getOrDefault(i)
    //            return set.inputs(i).map { .input($0) }
    //        case .modes:
    //            return modes.compactMap { $1 ? .mode($0) : nil }
    //        case .platforms(let s):
    //            let set: PlatformValue = platforms.getOrDefault(s)
    //            return set.platforms(s).map { .platform($0) }
    //        }
    //    }
    
    public func get(_ category: Category) -> Element {
        switch category {
        case .input:
            return .inputs(inputs)
        case .mode:
            return .modes(modes)
        case .platform:
            return .platforms(platforms)
        }
    }
    
    public func get(_ key: Key) -> Values {
        switch key {
        case .inputs(let i):
            let value: Inputs.Value = inputs.getOrDefault(i)
            return .inputs(value)
        case .modes:
            let value: Modes.Keys = modes.filter { $1 }.keys
            return .modes(value)
        case .platforms(let p):
            let value: Platforms.Value = platforms.getOrDefault(p)
            return .platforms(value)
        }
    }
    
    // TODO: Fix this
//    public func key(_ category: Category) -> [Key] {
//        
//    }
    
    public var keys: [Key] {
        [
            self.inputs.keys.map { .inputs($0) },
            self.modes.keys.map { .modes($0) },
            self.platforms.keys.map { .platforms($0) }
        ].flatMap { $0 }.sorted()
    }
    
}

extension TagsMap {
    
    private typealias Keys = [Category: Set<Key>]
    
    public typealias Builder = TagBuilder
    public typealias Category = TagCategory
    
    public typealias Inputs = [InputEnum: Set<StringBuilder>]
    public typealias Modes = [ModeEnum: Bool]
    public typealias Platforms = [SystemBuilder: Set<FormatBuilder>]
    
    public enum Key: Encapsulable {
        
        public static var allCases: [Self] {
            TagCategory.allCases.flatMap { type in
                switch type {
                case .input:
                    return Inputs.Key.cases.map(Self.inputs)
                case .mode:
                    return Modes.Key.cases.map(Self.modes)
                case .platform:
                    return Platforms.Key.cases.map(Self.platforms)
                }
            }
        }
        
        case inputs(Inputs.Key)
        case modes(Modes.Key)
        case platforms(Platforms.Key)
        
        public var enumeror: Enumeror {
            switch self {
            case .inputs(let i):
                return i
            case .modes(let m):
                return m
            case .platforms(let p):
                return p
            }
        }
        
    }
    
    public enum Element {
        case inputs(Inputs)
        case modes(Modes)
        case platforms(Platforms)
    }

    public enum Values {
        case inputs(Inputs.Value)
        case modes(Modes.Keys)
        case platforms(Platforms.Value)
    }
    
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
