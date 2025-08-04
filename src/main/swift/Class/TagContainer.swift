//
//  TagContainer.swift
//  autosave
//
//  Created by Asia Serrano on 7/28/25.
//

import Foundation

infix operator ++= : AdditionPrecedence


//fileprivate extension Map {
//    
////    func add(_ key: Key, _ element: Value.Element) -> Void {
////        self[key] = self.getOrDefault(key) + element
////    }
//    
//    static func +=(lhs: inout Self, rhs: MapElement?) -> Void {
//        if let rhs: MapElement = rhs {
//            let key: MapKey = rhs.mapKey
//            lhs[key] = lhs.getOrDefault(key) + rhs.builder
//        }
//    }
//    
//    static func -=(lhs: inout Self, rhs: MapElement?) -> Void {
//        if let rhs: MapElement = rhs {
//            let key: MapKey = rhs.mapKey
//            lhs[key] = lhs.getOrDefault(key) - rhs.builder
//        }
//    }
//    
//}

public struct TagContainer {
    
    // 1. keep up with map by category (input, platform, etc...)
    // 2. keep up with a direct array to avoid concatonation
    // 3. keep up with what tags are original, added, or deleted
    
    //    public static func build(_ tags: Tags) -> Self {
    //        var new: Self = .init()
    //        tags.map.forEach { new = new.add($0) }
    //        return new
    //    }
    
    public private(set) var inputs: Inputs = .init()
    public private(set) var modes: Modes = .init()
    public private(set) var platforms: Platforms = .init()
    
    private var map: [MapKey: Builders] = .init()
    
    
//    // these should not be changed
//    public private(set) var master: Builders = .init()
//    
//    // these are changed
//    public private(set) var current: Builders = .init()
//    public private(set) var added: Builders = .init()
//    public private(set) var deleted: Builders = .init()
    
}

public extension TagContainer {
    
    typealias Builder = TagBuilder
    typealias Builders = Set<Builder>
    typealias Category = TagCategory
    typealias Element = TagsElement
    
    static var random: Self {
        var map: Self = .init()
        
        var bool: Bool = false
        
        let range: Range<Int> = 0..<3
        
        Inputs.Key.cases.forEach { i in
            let strings: Inputs.Value = .random(range)
            strings.forEach { value in
                let input: InputBuilder = .init(i, value.trim)
                map += MapElement(.input(input), .inputs, .master, .current)
            }
        }
        
        Modes.Key.cases.forEach { mode in
            bool = .random()
            if bool {
                map += MapElement(.mode(mode), .modes, .master, .current)
            }
        }
        
        let systems: Set<SystemBuilder> = .random(range)
        
        systems.forEach { system in
            system.formatBuilders.forEach { format in
                bool = .random()
                if bool {
                    let platform: PlatformBuilder = .init(system, format)
                    map += MapElement(.platform(platform), .platforms, .master, .current)
                }
            }
        }
        
        return map
    }
    
    static func random(_ status: GameStatusEnum) -> Self {
        switch status {
        case .library:
            return .random
        case .wishlist:
            return .defaultValue
        }
    }
    
    static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
        var map: Self = .init()
        relations.forEach {
            if let builder: Builder = $0.getTagBuilder(properties) {
                switch builder {
                case .input:
                    map += MapElement(builder, .inputs, .master, .current)
                case .mode:
                    map += MapElement(builder, .modes, .master, .current)
                case .platform:
                    map += MapElement(builder, .platforms, .master, .current)
                }
            }
        }
        return map
    }
    
    static func +=(lhs: inout Self, rhs: Builder?) -> Void {
        if let builder: Builder = rhs {
            switch builder {
            case .input(let i):
                lhs.inputs += i
            case .mode(let m):
                lhs.modes += m
            case .platform(let p):
                lhs.platforms += p
            }
            
            
            if lhs.get(.master).lacks(builder) {
                lhs += MapElement(.added, builder)
            }
            
            lhs += MapElement(.current, builder)
            lhs -= MapElement(.deleted, builder)
            
            
            
//            if lhs.master.lacks(builder) {
//                lhs.added.insert(builder)
//            }
//
//            if lhs.deleted.contains(builder) {
//                lhs.deleted.remove(builder)
//            }
//
//            lhs.current.insert(builder)
        }
    }
    
    static func -=(lhs: inout Self, rhs: Builder?) -> Void {
        if let builder: Builder = rhs {
            switch builder {
            case .input(let i):
                lhs.inputs -= i
            case .mode(let m):
                lhs.modes -= m
            case .platform(let p):
                lhs.platforms -= p
            }

//            if lhs.get(.added).contains(builder) {
//                lhs.map -= MapElement(.added, builder)
//            }
            
            lhs -= MapElement(.added, builder)
            lhs -= MapElement(.current, builder)
            lhs += MapElement(.deleted, builder)
//
//            lhs.current.remove(builder)
//            lhs.deleted.insert(builder)
            
        }
    }
    
    func get(_ category: Category) -> Element {
        switch category {
        case .input:
            return .inputs(inputs)
        case .mode:
            return .modes(modes)
        case .platform:
            return .platforms(platforms)
        }
    }
    
    func get(_ tagType: TagType) -> Element {
        self.get(tagType.category)
    }
    
    func get(_ system: SystemBuilder?) -> Formats {
        if let system: SystemBuilder = system {
            return self.platforms.get(system.type).get(system)
        } else {
            return .defaultValue
        }
    }
    
    func equals(_ hash: Int) -> Bool {
        self.hashValue == hash
    }
    
    var current: Builders {
        self.map.getOrDefault(.current)
    }
    
    var isEmpty: Bool {
        self.current.isEmpty
    }
    
    var isNotEmpty: Bool {
        self.current.isNotEmpty
    }
    
    func contains(_ builder: Builder) -> Bool {
        switch builder {
        case .input(let i):
            return self.inputs.getOrDefault(i.type).contains(i.stringBuilder)
        case .mode(let m):
            return self.modes.enums.contains(m)
        case .platform(let p):
            return self.platforms.contains(p)
        }
    }
    
    enum MapKey: Enumerable {
        case master
        case added
        case deleted
        case current
        
        case inputs
        case modes
        case platforms
    }
    
    func getBuilders(_ mapKey: MapKey) -> Builders {
        switch mapKey {
        case .master: return self.get(.master)
        case .added:  return self.get(.added)
        case .deleted: return self.get(.deleted)
        case .current: return self.get(.current)
        case .inputs:
            return self.inputs.flatMap { key, value in
                value.map { Builder.input(.init(key, $0.trim))}
            }.toSet
        case .modes:
            return self.modes.compactMap { key, value in
                return value ? Builder.mode(key) : nil
            }.toSet
        case .platforms:
            return self.platforms.flatMap { _, value in
                value.flatMap { k, val in
                    val.values.flatMap { v in
                        v.map { Builder.platform(.init(k, $0)) }
                    }
                }
            }.toSet
        }
    }
    
    func getCount(_ mapKey: MapKey) -> Int {
        switch mapKey {
        case .master: return self.get(.master).count
        case .added:  return self.get(.added).count
        case .deleted: return self.get(.deleted).count
        case .current: return self.get(.current).count
        default:
            return self.getBuilders(mapKey).count
//        case .inputs: return self.inputs.count
//        case .modes: return self.modes.count
//        case .platforms: return self.platforms.count
        }
    }
    
}

fileprivate extension TagContainer {
    
    typealias Map = [MapKey: Builders]
    
//    static func ++=(lhs: inout Self, rhs: Builder?) -> Void {
//        lhs += rhs
//        if let builder: Builder = rhs {
//            lhs.map += MapElement(.master, builder)
////            lhs.master.insert(builder)
//        }
//    }

    struct MapElement {
        let keys: [MapKey]
        let builder: Builder
        
        init(_ mapKey: MapKey, _ builder: Builder) {
            self.keys = .init(mapKey)
            self.builder = builder
        }
        
        init(_ builder: Builder, _ keys: MapKey...) {
            self.keys = .init(keys)
            self.builder = builder
        }
        
    }
    
    func get(_ key: MapKey) -> Builders {
        self.map[key] ?? .defaultValue
    }
    
    static func +=(lhs: inout Self, rhs: [MapElement]) -> Void {
        rhs.forEach { lhs += $0 }
    }
    
    static func +=(lhs: inout Self, rhs: MapElement?) -> Void {
        if let rhs: MapElement = rhs {
            rhs.keys.forEach { key in
                let builder: Builder = rhs.builder
                switch key {
                case .master, .added, .deleted, .current:
                    lhs.map[key] = lhs.get(key) + builder
                default:
                    switch builder {
                    case .input(let input):
                        lhs.inputs += input
                    case .mode(let mode):
                        lhs.modes += mode
                    case .platform(let platform):
                        lhs.platforms += platform
                    }
                }
            }
        }
    }
    
    static func -=(lhs: inout Self, rhs: MapElement?) -> Void {
        if let rhs: MapElement = rhs {
            rhs.keys.forEach { key in
                lhs.map[key] = lhs.get(key) - rhs.builder
            }
        }
    }

//    static func +(lhs: Self, rhs: Builder?) -> Self {
//        var new: Self = lhs
//        new += rhs
//        return new
//    }
//    
//    static func -(lhs: Self, rhs: Builder?) -> Self {
//        var new: Self = lhs
//        new -= rhs
//        return new
//    }
    
    
//    func insert(_ key: MapKey, _ builder: Builder) -> Void {
//        let element: MapElement = .init(key, builder)
//        self.map += element
//    }
    
    
}

extension TagContainer: Stable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.current)
    }
    
}

extension TagContainer: Defaultable {
    
    public static var defaultValue: TagContainer { .init() }
    
}


/* Move these */

public enum TagsElement: Quantifiable {
    case inputs(Inputs)
    case modes(Modes)
    case platforms(Platforms)
    
    public var isEmpty: Bool {
        switch self {
        case .inputs(let inputs):
            return inputs.isEmpty
        case .modes(let modes):
            return modes.isEmpty
        case .platforms(let platforms):
            return platforms.isEmpty
        }
    }
    
}

