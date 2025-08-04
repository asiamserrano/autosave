////
////  Tags.swift
////  autosave
////
////  Created by Asia Serrano on 6/24/25.
////
//
//import Foundation
//
//public struct Tags {
//    
//    public static var random: Self {
//        var map: Self = .init()
//        
//        var bool: Bool = false
//        
//        let range: Range<Int> = 0..<3
//        
//        Inputs.Key.cases.forEach { i in
//            let strings: Inputs.Value = .random(range)
//            strings.forEach { value in
//                let input: InputBuilder = .init(i, value.trim)
//                map.add(.input(input))
//            }
//        }
//        
//        Modes.Key.cases.forEach { mode in
//            bool = .random()
//            if bool {
//                map.add(.mode(mode))
//            }
//        }
//        
//        let systems: Set<Platforms.Key> = .random(range)
//        
//        systems.forEach { system in
//            system.formatBuilders.forEach { format in
//                bool = .random()
//                if bool {
//                    let platform: PlatformBuilder = .init(system, format)
//                    map.add(.platform(platform))
//                }
//            }
//        }
//        
//        return map
//    }
//    
//    public static func random(_ status: GameStatusEnum) -> Self {
//        switch status {
//        case .library:
//            return .random
//        case .wishlist:
//            return .defaultValue
//        }
//    }
//    
//    public static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
//        var map: Self = .init()
//        
//        relations.forEach { relation in
//            if let key: PropertyModel = properties.get(relation.key_uuid) {
//                let property: PropertyBuilder = .fromModel(key)
//                switch property {
//                case .input(let i):
//                    let builder: TagBuilder = .input(i)
//                    map.add(builder)
//                case .selected(let s):
//                    switch s {
//                    case .mode(let m):
//                        let builder: TagBuilder = .mode(m)
//                        map.add(builder)
//                    default:
//                        if let value: PropertyModel = properties.get(relation.value_uuid),
//                           let platform: PlatformBuilder = .fromModels(key, value) {
//                            let builder: TagBuilder = .platform(platform)
//                            map.add(builder)
//                        }
//                    }
//                }
//            }
//        }
//        
//        return map
//    }
//    
//    public static func build(_ builders: Builders) -> Self {
//        var map: Self = .init()
//        
//        builders.forEach { builder in
//            map.add(builder)
//        }
//        
//        return map
//    }
//    
//    public static func build(_ tagBuilders: TagBuilders) -> Self {
//        let builders: Builders = tagBuilders.current
//        return .build(builders)
//    }
//    
//    public private(set) var inputs: Inputs = .init()
//    public private(set) var modes: Modes = .init()
//    public private(set) var platforms: Platforms = .init()
//    public private(set) var builders: Set<Builder> = .init()
//    
//}
//
//extension Tags: Defaultable {
//    
//    public static var defaultValue: Self { .init() }
//}
//
//extension Tags: Stable {
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.builders)
//    }
//    
//}
//
//public extension Tags {
//    
//    typealias Builder = TagBuilder
//    typealias Builders = Set<Builder>
//    typealias Category = TagCategory
//    typealias Inputs = [InputEnum: Set<StringBuilder>]
//    typealias Modes = [ModeEnum: Bool]
//    typealias Platforms = [SystemBuilder: Set<FormatBuilder>]
//    
//    enum Element {
//        case inputs(Inputs)
//        case modes(Modes)
//        case platforms(Platforms)
//        
//        public var isEmpty: Bool {
//            switch self {
//            case .inputs(let inputs):
//                return inputs.isEmpty
//            case .modes(let modes):
//                return modes.isEmpty
//            case .platforms(let platforms):
//                return platforms.isEmpty
//            }
//        }
//        
//    }
//    
//    mutating func set(_ element: Platforms.Element) -> Void {
//        let value: Platforms.Value = element.value
//        self.platforms[element.key] = value.isEmpty ? nil : value
//    }
//    
//    mutating func delete(_ system: SystemBuilder) -> Void {
//        let formats: Platforms.Value = .defaultValue
//        let element: Platforms.Element = (system, formats)
//        self.set(element)
//    }
//    
//    mutating func delete(_ system: SystemBuilder, _ format: FormatEnum) -> Void {
//        let formats: Platforms.Value = self.platforms.getOrDefault(system).remove(format)
//        let element: Platforms.Element = (system, formats)
//        self.set(element)
//    }
//    
//    mutating func delete(_ system: SystemBuilder, _ format: FormatBuilder) -> Void {
//        let formats: Platforms.Value = self.platforms.getOrDefault(system).remove(format)
//        let element: Platforms.Element = (system, formats)
//        self.set(element)
//    }
//    
//    
////    mutating func set(_ element: Element) -> Void {
////        switch element {
////        case .inputs(let inputs):
////            self.inputs = inputs
////        case .modes(let modes):
////            self.modes = modes
////        case .platforms(let platforms):
////            self.platforms = platforms
////        }
////    }
//    
//    mutating func add(_ builder: Builder) -> Void {
//        switch builder {
//        case .input(let i):
//            let key: Inputs.Key = i.type
//            var set: Inputs.Value = inputs.getOrDefault(key)
//            set.insert(i.stringBuilder)
//            self.inputs[key] = set
//        case .mode(let m):
//            self.modes[m] = true
//        case .platform(let p):
//            let key: Platforms.Key = p.system
//            var set: Platforms.Value = platforms.getOrDefault(key)
//            set.insert(p.format)
//            self.platforms[key] = set
//        }
//        
//        self.builders.insert(builder)
//    }
//    
//    mutating func delete(_ builder: Builder) -> Void {
//        switch builder {
//        case .input(let i):
//            let key: Inputs.Key = i.type
//            self.inputs[key] = inputs.getOrDefault(key).filter(i.stringBuilder)
//        case .mode(let m):
//            self.modes[m] = false
//        case .platform(let p):
//            let key: Platforms.Key = p.system
//            self.platforms[key] = platforms.getOrDefault(key).filter(p.format)
//        }
//        
//        self.builders.remove(builder)
//    }
//    
//    func equals(_ hash: Int) -> Bool {
//        self.hashValue == hash
//    }
//    
//    func contains(_ builder: Builder) -> Bool {
//        switch builder {
//        case .input(let i):
//            return self.inputs.getOrDefault(i.type).contains(i.stringBuilder)
//        case .mode(let m):
//            return self.modes.enums.contains(m)
//        case .platform(let p):
//            return self.platforms.getOrDefault(p.system).contains(p.format)
//        }
//    }
//            
//    func get(_ category: Category) -> Element? {
//        let element: Element = self.getElement(category)
//        return element.isEmpty ? nil : element
//    }
//    
//    func get(_ tagType: TagType) -> Element {
//        let category: Category = tagType.category
//        return getElement(category)
//    }
//
//    var isEmpty: Bool {
//        self.builders.isEmpty
//    }
//    
//    var isNotEmpty: Bool {
//        self.builders.isNotEmpty
//    }
//    
//}
//
//private extension Tags {
//    
//    enum Values {
//        case inputs(Inputs.Value)
//        case modes(Modes.Keys)
//        case platforms(Platforms.Value)
//    }
//    
//    func getElement(_ category: Category) -> Element {
//        switch category {
//        case .input:
//            return .inputs(inputs)
//        case .mode:
//            return .modes(modes)
//        case .platform:
//            return .platforms(platforms)
//        }
//    }
//    
//}
