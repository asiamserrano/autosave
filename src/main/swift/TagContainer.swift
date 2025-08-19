//
//  TagContainer.swift
//  autosave
//
//  Created by Asia Serrano on 7/28/25.
//

import Foundation

public struct TagContainer {
    
    public var builders: TagBuilders = .defaultValue
    
}

//private extension TagContainer {
//    
//    static var RANDOM_RANGE: Range<Int> = 0..<3
//    
//}
//
//public extension TagContainer {
//    
//    typealias Builder = TagBuilder
//    typealias Builders = SortedSet<Builder>
//    
//    enum Element: Quantifiable {
//        case inputs(Inputs)
//        case modes(Modes)
//        case platforms(Platforms)
//
//        public var quantity: Int {
//            switch self {
//            case .inputs(let inputs):
//                return inputs.count
//            case .modes(let modes):
//                return modes.count
//            case .platforms(let platforms):
//                return platforms.count
//            }
//        }
//
//    }
//    
//    static func ==(lhs: Self, rhs: Builders) -> Bool {
//        lhs.builders == rhs
//    }
//    
//    static func +=(lhs: inout Self, rhs: Builder?) -> Void {
//        if let builder: Builder = rhs {
//            switch builder {
//            case .input(let input):
//                lhs.inputs += input
//            case .mode(let mode):
//                lhs.modes += mode
//            case .platform(let platform):
//                lhs.platforms += platform
//            }
//            
//            lhs.builders += builder
//        }
//    }
//    
//    static func -=(lhs: inout Self, rhs: Builder?) -> Void {
//        if let builder: Builder = rhs {
//            switch builder {
//            case .input(let input):
//                lhs.inputs -= input
//            case .mode(let mode):
//                lhs.modes -= mode
//            case .platform(let platform):
//                print(platform)
//                lhs.platforms -= platform
//            }
//            
//            lhs.builders -= builder
//        }
//    }
//    
//    static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
//        var new: Self = .init()
//        relations.forEach {
//            if let builder: Builder = $0.getTagBuilder(properties) {
//                new += builder
//            }
//        }
//        return new
//    }
//    
//    static func random(_ status: GameStatusEnum) -> Self {
//        switch status {
//        case .library:
//            return .random
//        case .wishlist:
//            return .defaultValue
//        }
//    }
//
//    static var random: Self {
//        var new: Self = .init()
//        
//        var bool: Bool = false
//        
//        InputEnum.cases.forEach { i in
//            let strings: StringBuilders = .random(RANDOM_RANGE)
//            strings.forEach { value in
//                let input: InputBuilder = .init(i, value.trim)
//                new += (.input(input))
//            }
//        }
//        
//        ModeEnum.allCases.forEach { mode in
//            bool = .random()
//            if bool {
//                new += (.mode(mode))
//            }
//        }
//        
//        let systems: SortedSet<SystemBuilder> = .random(RANDOM_RANGE)
//        
//        systems.forEach { system in
//            system.formatBuilders.forEach { format in
//                bool = .random()
//                if bool {
//                    let platform: PlatformBuilder = .init(system, format)
//                    new += (.platform(platform))
//                }
//            }
//        }
//        
//        return new
//    }
//    
//    func get(_ category: TagCategory) -> Element {
//        switch category {
//        case .input:
//            return .inputs(self.inputs)
//        case .mode:
//            return .modes(self.modes)
//        case .platform:
//            return .platforms(self.platforms)
//        }
//    }
//    
//    func get(_ tagType: TagType) -> Element {
//        self.get(tagType.category)
//    }
//    
//    func get(_ system: Systems.K?) -> Formats {
//        if let system: Systems.K = system {
//            return self.platforms.get(system)
//        } else {
//            return .defaultValue
//        }
//    }
//    
//    func contains(_ builder: Builder) -> Bool {
//        self.builders.contains(builder)
//    }
//    
//    var systems: [Systems.K] {
//        self.platforms.flatMap { $0.value.keys }
//    }
//    
//}
//
extension TagContainer: Stable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.builders)
    }
    
}

extension TagContainer: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

extension TagContainer: Quantifiable {
    
    public var quantity: Int { self.builders.count }
    
}


////infix operator ++= : AdditionPrecedence
////
////public struct TagContainer {
////        
////    private var set: TagSet = .init()
////    private var map: TagMap = .init()
////    
////}
////
////public extension TagContainer {
////    
////    typealias Builder = TagBuilder
////    typealias Builders = Set<Builder>
////    typealias Category = TagCategory
////    typealias Element = TagsElement
////    
////    static var random: Self {
////        var new: Self = .init()
////        
////        var bool: Bool = false
////        
////        func update(_ builder: Builder) -> Void {
////            new.set += builder
////            new.map += .init(builder, .master, .current)
////        }
////        
////        Inputs.Key.cases.forEach { i in
////            let strings: Inputs.Value = .random(RANDOM_RANGE)
////            strings.forEach { value in
////                let input: InputBuilder = .init(i, value.trim)
////                update(.input(input))
////            }
////        }
////        
////        ModeEnum.allCases.forEach { mode in
////            bool = .random()
////            if bool {
////                update(.mode(mode))
////            }
////        }
////        
////        let systems: Set<SystemBuilder> = .random(RANDOM_RANGE)
////        
////        systems.forEach { system in
////            system.formatBuilders.forEach { format in
////                bool = .random()
////                if bool {
////                    let platform: PlatformBuilder = .init(system, format)
////                    update(.platform(platform))
////                }
////            }
////        }
////        
////        return new
////    }
////    
////    static func random(_ status: GameStatusEnum) -> Self {
////        switch status {
////        case .library:
////            return .random
////        case .wishlist:
////            return .defaultValue
////        }
////    }
////    
////    static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
////        var new: Self = .init()
////        relations.forEach {
////            if let builder: Builder = $0.getTagBuilder(properties) {
////                new.set += builder
////                switch builder {
////                case .input:
////                    new.map += .init(builder, .master, .current)
////                case .mode:
////                    new.map += .init(builder, .master, .current)
////                case .platform:
////                    new.map += .init(builder, .master, .current)
////                }
////            }
////        }
////        return new
////    }
////    
////    static func +=(lhs: inout Self, rhs: Builder?) -> Void {
////        
////        if let builder: Builder = rhs {
////            lhs.set += builder
////
////            if lhs.map.get(.master).lacks(builder) {
////                lhs.map += .init(.added, builder)
////            }
////            
////            lhs.map += .init(.current, builder)
////            lhs.map -= .init(.deleted, builder)
////            
////        }
////    }
////    
////    static func -=(lhs: inout Self, rhs: Builder?) -> Void {
////        if let builder: Builder = rhs {
////            lhs.set -= builder
////            lhs.map -= .init(.added, builder)
////            lhs.map -= .init(.current, builder)
////            lhs.map -= .init(.deleted, builder)
////        }
////    }
////    
////    func get(_ category: Category) -> Element {
////        switch category {
////        case .input:
////            return .inputs(self.set.inputs)
////        case .mode:
////            return .modes(self.set.modes)
////        case .platform:
////            return .platforms(self.set.platforms)
////        }
////    }
////    
////    func get(_ tagType: TagType) -> Element {
////        self.get(tagType.category)
////    }
////    
////    func get(_ system: SystemBuilder?) -> Formats {
//////        if let system: SystemBuilder = system {
//////            return self.set.platforms.get(system.type).get(system)
//////        } else {
//////            return .defaultValue
//////        }
////        
////        return .defaultValue
////    }
////    
////    func equals(_ hash: Int) -> Bool {
////        self.hashValue == hash
////    }
////    
////    func contains(_ builder: Builder) -> Bool {
//////        switch builder {
//////        case .input(let i):
//////            return self.set.inputs.get(i.type).contains(i.stringBuilder)
//////        case .mode(let m):
//////            return self.set.modes.contains(m)
//////        case .platform(let p):
//////            return self.set.platforms.contains(p)
//////        }
////        
////        return false
////    }
////    
////    var current: Builders {
////        self.map.get(.current)
////    }
////    
////    var deleted: Builders {
////        self.map.get(.deleted)
////    }
////    
////    var platforms: Platforms {
////        self.set.platforms
////    }
////    
////    var added: Builders {
////        self.map.get(.added)
////    }
////    
////}
////
////extension TagContainer: Quantifiable {
////    
////    public var isEmpty: Bool {
////        self.current.isEmpty
////    }
////    
////}
////
////private extension TagContainer {
////    
////    static var RANDOM_RANGE: Range<Int> = 0..<3
////    
////}
////
////extension TagContainer: Stable {
////    
////    public func hash(into hasher: inout Hasher) {
////        hasher.combine(self.current)
////    }
////    
////}
////
////extension TagContainer: Defaultable {
////    
////    public static var defaultValue: TagContainer { .init() }
////    
////}
////
////
/////* Move these */
////
////fileprivate struct TagMap {
////    
////    typealias Builder = TagContainer.Builder
////    typealias Builders = TagContainer.Builders
////    typealias Map = [Key: Builders]
////    
////    enum Key: Enumerable {
////        case master
////        case added
////        case deleted
////        case current
////    }
////    
////    struct Element {
////        let keys: [Key]
////        let builder: Builder
////        
////        init(_ key: Key, _ builder: Builder) {
////            self.keys = .init(key)
////            self.builder = builder
////        }
////        
////        init(_ builder: Builder, _ keys: Key...) {
////            self.keys = .init(keys)
////            self.builder = builder
////        }
////        
////    }
////    
////    private var map: Map = .init()
////    
////    static func +=(lhs: inout Self, rhs: [Element]) -> Void {
////        rhs.forEach { lhs += $0 }
////    }
////    
////    static func +=(lhs: inout Self, rhs: Element?) -> Void {
////        if let rhs: Element = rhs {
////            rhs.keys.forEach { key in
////                let builder: Builder = rhs.builder
////                lhs.map[key] = lhs.get(key) + builder
////            }
////        }
////    }
////    
////    static func -=(lhs: inout Self, rhs: Element?) -> Void {
////        if let rhs: Element = rhs {
////            rhs.keys.forEach { key in
////                lhs.map[key] = lhs.get(key) - rhs.builder
////            }
////        }
////    }
////    
////    func get(_ key: Key) -> Builders {
////        self.map[key] ?? .defaultValue
////    }
////    
////}
////
////fileprivate struct TagSet {
////    
////    typealias Builder = TagContainer.Builder
////    typealias Builders = TagContainer.Builders
////    
////    static func +=(lhs: inout Self, rhs: Builder?) -> Void {
////        if let builder: Builder = rhs {
////            switch builder {
////            case .input(let input):
////                lhs.inputs += input
////            case .mode(let mode):
////                lhs.modes += mode
////            case .platform(let platform):
////                print(platform)
//////                lhs.platforms += platform
////            }
////        }
////    }
////    
////    static func -=(lhs: inout Self, rhs: Builder?) -> Void {
////        if let builder: Builder = rhs {
////            switch builder {
////            case .input(let input):
////                lhs.inputs -= input
////            case .mode(let mode):
////                lhs.modes -= mode
////            case .platform(let platform):
////                print(platform)
//////                lhs.platforms -= platform
////            }
////        }
////    }
////    
////    public private(set) var inputs: Inputs = .init()
////    public private(set) var modes: Modes = .init()
////    public private(set) var platforms: Platforms = .init()
////    
////}
////
////public enum TagsElement: Quantifiable {
////    case inputs(Inputs)
////    case modes(Modes)
////    case platforms(Platforms)
////    
////    public var isEmpty: Bool {
////        switch self {
////        case .inputs(let inputs):
////            return inputs.isEmpty
////        case .modes(let modes):
////            return modes.isEmpty
////        case .platforms(let platforms):
////            return platforms.isEmpty
////        }
////    }
////    
////}
////
/////*
//// enum MapKey: Enumerable {
////     case master
////     case added
////     case deleted
////     case current
////     
////     case inputs
////     case modes
////     case platforms
//// }
//// */
